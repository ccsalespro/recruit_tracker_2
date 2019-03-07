require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  test "receive message" do
    recruit = FactoryBot.create :recruit

    post messages_reply_path({
      'From' => recruit.phone_number,
      'Body' => 'test message'
    })

    assert_equal 1, Message.count
    assert_equal 0, GeneralMessage.count
  end
end
