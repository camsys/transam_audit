FactoryBot.define do

  factory :audit do
    name 'Test Audit'
    description 'Test Audit Description'
    instructions 'test instructions'
    start_date Date.today.beginning_of_month
    end_date Date.today.end_of_month
    auditor_class_name 'AssetAuditor'
    association :activity
    filterable_class_name 'AssetType'
  end

end
