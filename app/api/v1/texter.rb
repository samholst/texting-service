module V1
  class Texter < Grape::API
    version 'v1'
    format :json
    prefix :api

    helpers do
      def current_user
        @current_user ||= AccessKey.find_by_token(request.headers["X-Api-Key"])&.user
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end

    resource :texter do
      desc 'Send a message to a phone number.'
      params do
        requires :to_number, type: Integer, desc: 'Recipient phone number.'
        requires :message, type: String, desc: 'Text message body.'
      end
      post :send_message do
        authenticate!

        text_message = current_user.text_messages.create(
          to_number: params[:to_number],
          message: params[:message]
        )

        unless text_message.valid?
          error!(errors: text_message.errors.messages)
        end

        callback_url = "#{request.env["rack.url_scheme"]}://#{request.env["HTTP_HOST"]}/api/v1/texter/delivery_status"
        res = ParentSquare::API.new(text_message, callback_url).send_text

        if res.success?
          text_message.update(message_id: JSON.parse(res.body)["message_id"])
          present(res)
        else
          error!("Please try again. Message could not be sent.")
        end
      end

      desc 'Receives callback for delivery status of sent text message.'
      params do
        requires :status, type: String, values: %w(delivered failed invalid), desc: 'Status of sent text message.'
        requires :message_id, type: String, desc: 'Message ID.'
      end
      post :delivery_status do
        # Can't authenicate request credentials here in callback due to ParentSquare test API limitation

        text_message = TextMessage.find_by_message_id(params[:message_id])

        if text_message
          text_message.update!(status: params[:status])
        else
          error!("The message_id is invalid.")
        end

        if params[:status] == InvalidNumber::STATUS && !InvalidNumber.where(number: text_message.to_number).exists?
          InvalidNumber.create(number: text_message.to_number) 
        end

        present(successful: true)
      end
    end
  end
end
