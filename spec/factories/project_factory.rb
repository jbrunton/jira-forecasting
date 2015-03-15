FactoryGirl.define do
  factory :project do
    sequence(:name) { |k| "Project #{k}" }
    sequence(:domain) { |k| "http://www.example#{k}.com" }
  end
end
