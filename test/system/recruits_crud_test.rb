require "application_system_test_case"

class RecruitsCrudTest < ApplicationSystemTestCase
  setup :login

  test 'make recruit from general message' do
    gm = FactoryBot.create :general_message

    visit general_messages_path
    assert_text gm.body
    click_on 'Make New Recruit'

    fill_in 'recruit_name', with: 'Recruit From General Message'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Description', with: 'test description'
    fill_in 'Start date', with: '2019/02/22'
    fill_in 'recruit_tasks_attributes_0_name', with: 'test task'
    fill_in 'recruit_tasks_attributes_0_due_date', with: '2019/03/04'
    click_on "Save"

    assert_text 'Recruit From General Message'
    assert_text gm.number

    assert_equal 1, Recruit.count
    recruit = Recruit.find_by_phone_number gm.number
    assert_equal 1, recruit.messages.count
  end

  test 'create recruit' do
    click_on 'New Recruit'
    fill_in 'recruit_name', with: 'Test Recruit'
    fill_in 'Phone number', with: '1234567890'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Description', with: 'test description'
    fill_in 'Start date', with: '2019/02/22'
    fill_in 'recruit_tasks_attributes_0_name', with: 'test task'
    fill_in 'recruit_tasks_attributes_0_due_date', with: '2019/03/04'
    click_on "Save"

    assert_text 'Test Recruit'
    assert_text '+11234567890'
  end

  test 'view and edit recruit' do
    recruit = FactoryBot.create :recruit
    visit recruit_path(recruit)

    assert_text recruit.name
    assert_text recruit.phone_number

    click_on 'Edit'
    fill_in 'Name', with: 'changed recruit name'
    click_on 'Save'

    assert_text 'changed recruit name'
  end

  test 'delete recruit' do
    recruit = FactoryBot.create :recruit
    visit recruit_path(recruit)

    assert_text recruit.name
    assert_text recruit.phone_number

    click_on "Delete"
    unless Capybara.current_driver == :rack_test_ujs
      page.accept_alert "Are you sure?"
    end

    assert_equal Recruit.count, 0
  end

end
