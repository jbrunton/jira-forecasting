FactoryGirl.define do
  factory :project do
    sequence(:name) { |k| "Project #{k}" }
    sequence(:domain) { |k| "http://www.example#{k}.com" }
    sequence(:rapid_board_id) { |k| k }
  end
end
