require "application_system_test_case"

class TasksCrudTest < ApplicationSystemTestCase
  setup :login

  test 'send message' do
    recruit = FactoryBot.create :recruit

    visit recruit_path(recruit)
    click_on "Messages"

    fill_in "message_body", with: 'test message'
    click_on "Send"

    assert_text 'test message'
  end

end
