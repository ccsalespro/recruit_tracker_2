require "application_system_test_case"

class TasksCrudTest < ApplicationSystemTestCase
  setup :login

  test 'create and view task' do
    recruit = FactoryBot.create :recruit

    visit recruit_path(recruit)
    click_on "Add Task"
    fill_in "Name", with: 'test task'
    fill_in "Due date", with: '2019/02/22'
    click_on "Save Task"

    assert_text "test task"
    assert_equal 1, Task.count
  end

  test 'edit task' do
    recruit = FactoryBot.create :recruit
    task = FactoryBot.create :task, recruit: recruit

    visit recruit_path(recruit, tab: 'uncomplete_tasks')
    assert_text recruit.name
    assert_text task.name

    within_element("#task_#{task.id}") {click_on "Edit"}

    fill_in "Name", with: 'updated task'
    click_on "Save Task"

    assert_text "updated task"
  end

  test 'complete task' do
    recruit = FactoryBot.create :recruit
    task = FactoryBot.create :task, recruit: recruit

    visit recruit_path(recruit, tab: 'uncomplete_tasks')
    assert_text recruit.name
    assert_text task.name

    click_on "Mark Complete"
    refute_text task.name
  end

  test 'uncomplete task' do
    recruit = FactoryBot.create :recruit
    task = FactoryBot.create :task, completed_at: '2019/02/22', recruit: recruit

    visit recruit_path(recruit, tab: 'complete_tasks')
    assert_text recruit.name
    assert_text task.name

    click_on "Mark Uncomplete"
    refute_text task.name
  end

end
