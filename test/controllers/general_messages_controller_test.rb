require 'test_helper'

class GeneralMessagesControllerTest < ActionDispatch::IntegrationTest
  test "receive general message" do
    post messages_reply_path({
      'From' => '+11234567890',
      'Body' => 'test message'
    })

    assert_equal 1, GeneralMessage.count
    assert_equal 0, Message.count
  end
end
