FactoryBot.define do
  factory :message do
    body 'message body'
    from_recruit true
    read_at '2019/02/22'
    recruit
  end
end
