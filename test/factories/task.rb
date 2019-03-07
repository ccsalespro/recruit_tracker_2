FactoryBot.define do
  factory :task do
    name 'test task'
    due_date '2019/02/22'
    completed_at nil
    recruit
  end
end
