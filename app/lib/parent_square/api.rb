# frozen_string_literal: true

module ParentSquare
  class API
    include HTTParty

    base_uri "https://mock-text-provider.parentsquare.com"

    attr_reader :text_message, :callback_url, :provider

    def initialize(text_message, callback_url)
      @text_message = text_message
      @callback_url = callback_url
      @provider = LoadBalancer.get_provider
    end

    def send_text
      uri_options = options

      res = self.class.post(
        provider,
        uri_options
      )

      unless res.success?
        @provider = LoadBalancer.backup_provider(provider)

        res = self.class.post(
          provider,
          uri_options
        )
      end

      res
    end

    private

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
