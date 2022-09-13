require "test_helper"

class ParentSquare::LoadBalancerTest < ActiveSupport::TestCase
  it "tests get_provider method" do
    assert_includes(ParentSquare::LoadBalancer::PROVIDERS_WEIGHTED, ParentSquare::LoadBalancer.get_provider)
  end

  it "tests backup_provider method" do
    first_provider = ParentSquare::LoadBalancer.get_provider
    backup_provider = ParentSquare::LoadBalancer.backup_provider(first_provider)

    assert_not_equal(first_provider, backup_provider)
  end
end
