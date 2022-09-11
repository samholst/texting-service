module V1
  class Texter < Grape::API
    version 'v1'
    format :json
    prefix :api

    helpers do
      def current_user
        @current_user ||= AccessKey.find_by_token(request.headers["X-Api-Key"])
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

        text_message = TextMessage.create(
          to_number: params[:to_number],
          message: params[:message]
        )

        res = ParentSquare::API.send_text(text_message)

        if res.success?
          text_message.update(message_id: JSON.parse(res.body)["message_id"])
          present res
        else
          error!("Please try again. Message could not be sent.")
        end
      end
    end
  end
end
