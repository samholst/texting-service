# frozen_string_literal: true

module ParentSquare
  class API
    include HTTParty

    CALLBACK_URL = ""

    base_uri "https://mock-text-provider.parentsquare.com"

    def self.send_text(text_message)
      provider = LoadBalancer.get_provider
      uri_options = options(text_message)

      res = post(
        provider,
        uri_options
      )

      unless res.success?
        backup_provider = LoadBalancer.backup_provider(provider)

        res = post(
          backup_provider,
          uri_options
        )
      end

      res
    end

    def self.options(text_message)
      {
        body: {
          to_number: text_message.to_number,
          message: text_message.message,
          callback_url: "https://example.com/delivery_status"
        }.to_json
      }
    end
  end
end
