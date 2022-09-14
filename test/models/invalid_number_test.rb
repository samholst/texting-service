require 'test_helper'

class InvalidNumberTest < ActiveSupport::TestCase
  let(:invalid_number) { InvalidNumber.new }

  it "requires a number" do
    refute(invalid_number.valid?) 
  end

  it "requires a number" do
    invalid_number.number = "1234567890"
    assert(invalid_number.valid?) 
  end
end
