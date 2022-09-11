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
        requires :phone_number, type: Integer, desc: 'Recipient phone number.'
        requires :body, type: String, desc: 'Text message body.'
      end
      post :send_message do
        authenticate!

        present "Yippie!"
      end
    end
  end
end
