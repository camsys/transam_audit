FactoryGirl.define do

  factory :audit do
    name 'Test Audit'
    description 'Test Audit Description'
    instructions 'test instructions'
    schedule 'test schedule'
    auditor_class_name 'AssetAuditor'
    association :activity
  end

end
