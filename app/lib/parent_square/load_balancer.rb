# frozen_string_literal: true

module ParentSquare
  class LoadBalancer
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

    def self.get_provider
      PROVIDERS_WEIGHTED[rand(PROVIDERS_WEIGHT_SUM)]
    end

    def self.backup_provider(previous_provider)
      PROVIDERS.reject { |p| p[:path] == previous_provider }.first[:path]
    end
  end
end
