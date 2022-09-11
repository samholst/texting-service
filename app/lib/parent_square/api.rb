# frozen_string_literal: true

module ParentSquare
  class API
    include HTTParty

    base_uri "https://mock-text-provider.parentsquare.com"

    PROVIDER_ONE = { path: "/provider1", weight: 7 }.freeze
    PROVIDER_TWO = { path: "/provider2", weight: 3 }.freeze

    PROVIDERS = [PROVIDER_ONE, PROVIDER_TWO].freeze
    PROVIDERS_WEIGHT_SUM = PROVIDERS.sum { |p| p[:weight] }.freeze

    PROVIDERS_WEIGHTED = [].tap do |arr|
      PROVIDERS.each do |provider|
        provider[:weight].times do 
          arr << provider[:path]
        end
      end
    end.shuffle.freeze

    def self.send_text(text_message)
      provider = PROVIDERS_WEIGHTED[rand(PROVIDERS_WEIGHT_SUM)]
      uri_options = options(text_message)

      res = post(
        provider,
        uri_options
      )

      unless res.success?
        fallback_provider = PROVIDERS.reject { |p| p[:path] == provider }.first[:path]

        res = post(
          fallback_provider,
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
