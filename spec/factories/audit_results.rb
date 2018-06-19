FactoryBot.define do

  factory :audit_result do
    association :audit
    audit_result_type_id 1
    auditable_type 'Asset'
    class_name 'Asset'
  end
end
