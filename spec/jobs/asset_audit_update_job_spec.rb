require 'rails_helper'

RSpec.describe AuditableUpdateJob, :type => :job do

  let(:test_audit) { create(:audit) }
  let(:test_subtype) { create(:asset_subtype)}
  let(:test_parent_policy) { create(:parent_policy, type: test_subtype.asset_type_id, subtype: test_subtype.id) }
  let(:test_policy) { create(:policy, organization: test_parent_policy.organization, parent: test_parent_policy) }
  let(:test_asset) { create(:buslike_asset, asset_subtype: test_subtype, organization: test_policy.organization) }

  it '.run' do
    Audit.destroy_all
    AuditResult.destroy_all
    test_audit.update!(:activity => create(:activity, :start_date => Date.today - 3.days, :end_date => Date.today + 3.days))
    test_audit_result = create(:audit_result, :auditable => test_asset, :audit => test_audit, :organization => test_asset.organization, :audit_result_type_id => AuditResultType::AUDIT_RESULT_PASSED, :class_name => test_asset.asset_type.name, :filterable => test_asset.asset_type)
    AuditableUpdateJob.new(test_audit, test_asset).run
    test_audit_result.reload

    expect(test_audit_result.audit_result_type.id).to eq(AuditResultType::AUDIT_RESULT_FAILED)
  end

  it '.check' do
    expect{AuditableUpdateJob.new(nil, test_asset.object_key).check}.to raise_error(ArgumentError, "audit can't be blank ")
  end
  it '.prepare' do
    test_asset.save!
    allow(Time).to receive(:now).and_return(Time.utc(2000,"jan",1,20,15,1))

    expect(Rails.logger).to receive(:debug).with("Executing AuditableUpdateJob at #{Time.now.to_s} for Audit #{test_audit} and Auditable #{test_asset.object_key}")
    AuditableUpdateJob.new(test_audit, test_asset.object_key).prepare
  end
end
