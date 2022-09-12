# frozen_string_literal: true

module ParentSquare
  class API
    include HTTParty

    base_uri "https://mock-text-provider.parentsquare.com"

    attr_reader :text_message, :callback_url

    def initialize(text_message, callback_url)
      @text_message = text_message
      @callback_url = callback_url
    end

    def send_text
      provider = LoadBalancer.get_provider
      uri_options = options

      res = self.class.post(
        provider,
        uri_options
      )

      unless res.success?
        backup_provider = LoadBalancer.backup_provider(provider)

        res = self.class.post(
          backup_provider,
          uri_options
        )
      end

      res
    end

    def options
      {
        body: {
          to_number: text_message.to_number,
          message: text_message.message,
          callback_url: callback_url
        }.to_json
      }
    end
  end
end
