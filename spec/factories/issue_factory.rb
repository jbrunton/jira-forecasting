FactoryGirl.define do
  factory :issue do
    sequence(:key) { |k| "DEMO-#{k}" }
    sequence(:summary) { |k| "Issue #{k}" }
    issue_type 'issue'
    
    factory :epic do
      sequence(:summary) { |k| "Epic #{k}" }
      issue_type 'epic'
    end
  end
end