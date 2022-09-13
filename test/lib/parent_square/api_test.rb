require "test_helper"

class ParentSquare::APITest < ActiveSupport::TestCase
  let(:user) { users :one }
  let(:text_message) { text_messages :one }
  let(:callback_url) { "https://example.com/callback" }
  let(:options) {
    {
      body: {
        to_number: text_message.to_number,
        message: text_message.message,
        callback_url: callback_url
      }.to_json
    }
  }

  let(:res) { OpenStruct.new(:success? => true, body: { message_id: "2b8d100f-7e10-402c-940f-0fcfb458d3e9" }.to_json) }
  let(:res_failure) { OpenStruct.new(:success? => false, body: { error: "Something went wrong." }.to_json) }

  before do
    @subject = ParentSquare::API.new(text_message, callback_url)
  end

  it "tests initialize method" do
    assert_equal(@subject.text_message, text_message)
    assert_equal(@subject.callback_url, callback_url)
  end

  it "tests send_post method with success" do
    ParentSquare::API.expects(:post).with(@subject.provider, options).returns(res)

    assert_equal(@subject.send_text, res)
  end

  it "tests send_post method changes providers on failure" do
    first_provider = @subject.provider
    ParentSquare::API.expects(:post).at_most(2).returns(res_failure)

    assert_equal(@subject.send_text, res_failure)
    assert_not_equal(first_provider, @subject.provider)
  end
end
