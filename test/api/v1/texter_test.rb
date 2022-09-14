require "test_helper"

class V1::TexterTest < ActionDispatch::IntegrationTest
  let(:user) { users :one }
  let(:base_v1_url) { "/api/v1/texter" }
  let(:res) { OpenStruct.new(:success? => true, body: { message_id: "2b8d100f-7e10-402c-940f-0fcfb458d3e9" }.to_json) }
  let(:res_failure) { OpenStruct.new(:success? => false, body: { error: "Something went wrong." }.to_json) }
  let(:text_message) { text_messages :one }

  describe 'api key' do
    it "should error with no api key" do
        post base_v1_url + "/send_message", params: { to_number: "1234567890", message: "hi" }

      assert_equal(response.status, 401)
    end 
  end

  describe 'send_message' do
    it "tests valid params" do
      ParentSquare::API.any_instance.expects(:send_text).returns(res)
      
      assert_difference('TextMessage.count') do
        post base_v1_url + "/send_message", params: { to_number: 1234567890, message: "hi" }, headers: { "X-Api-Key": user.access_keys.first.token }
      end

      last_message = TextMessage.last
      assert_equal(last_message.message_id, JSON.parse(res.body)["message_id"])
      assert_equal(last_message.status, TextMessage::STATUS_PROCESSING)
      value(response).must_be :successful?
    end

    it "tests invalid params" do
      InvalidNumber.create!(number: text_message.to_number)
      ParentSquare::API.any_instance.expects(:send_text).at_most(0)
      
      assert_no_difference('TextMessage.count') do
        post base_v1_url + "/send_message", params: { to_number: "1234567890", message: "hi" }, headers: { "X-Api-Key": user.access_keys.first.token }
      end

      assert_equal(response.status, 400)
      assert_equal(JSON.parse(response.body), { "errors" => { "to_number" => ["The number you provided is invalid."] } })
    end
  end

  describe 'delivery_status' do
    it "tests delivered status" do
      post base_v1_url + "/delivery_status", params: { status: "delivered", message_id: text_message.message_id }
      value(response).must_be :successful?
      assert_equal(text_message.reload.status, TextMessage::STATUS_DELIVERED)
    end


    it "tests invalid status" do
      assert_difference('InvalidNumber.count') do
        post base_v1_url + "/delivery_status", params: { status: "invalid", message_id: text_message.message_id }
      end

      value(response).must_be :successful?
      assert_equal(text_message.reload.status, TextMessage::STATUS_INVALID)
    end

    it "tests invalid message_id" do
      assert_no_difference('InvalidNumber.count') do
        post base_v1_url + "/delivery_status", params: { status: "invalid", message_id: "blah" }
      end

      assert_equal(response.status, 400)
      assert_equal(JSON.parse(response.body), { "error" => "The message_id is invalid." })
    end
  end
end
