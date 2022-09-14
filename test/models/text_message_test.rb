require 'test_helper'

class TextMessageTest < ActiveSupport::TestCase
  let(:text_message) { TextMessage.new }
  let(:user) { users :one }

  it "test invalid content" do
    refute(text_message.valid?) 
  end

  it "requires a number and message" do
    text_message.to_number = "2234567890"
    text_message.message = "hi"
    text_message.user = user

    assert(text_message.valid?) 
  end
end
