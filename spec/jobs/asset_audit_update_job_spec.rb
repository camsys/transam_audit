require 'rails_helper'

RSpec.describe AssetAuditUpdateJob, :type => :job do

  let(:test_audit) { create(:audit) }
  let(:test_asset) { create(:buslike_asset) }

  it '.run' do
    Audit.destroy_all
    AuditResult.destroy_all
    test_audit.update!(:activity => create(:activity, :start_date => Date.today - 3.days, :end_date => Date.today + 3.days))
    test_audit_result = create(:audit_result, :auditable => test_asset, :audit => test_audit, :organization => test_asset.organization, :audit_result_type_id => AuditResultType::AUDIT_RESULT_PASSED, :class_name => test_asset.asset_type.name)
    AssetAuditUpdateJob.new(test_audit, test_asset.object_key).run
    test_audit_result.reload

    expect(test_audit_result.audit_result_type.id).to eq(AuditResultType::AUDIT_RESULT_FAILED)
  end

  it '.check' do
    expect{AssetAuditUpdateJob.new(nil, test_asset.object_key).check}.to raise_error(ArgumentError, "audit can't be blank ")
  end
  it '.prepare' do
    test_asset.save!
    allow(Time).to receive(:now).and_return(Time.utc(2000,"jan",1,20,15,1))

    expect(Rails.logger).to receive(:debug).with("Executing AssetAuditUpdateJob at #{Time.now.to_s} for Audit #{test_audit} and Asset #{test_asset.object_key}")
    AssetAuditUpdateJob.new(test_audit, test_asset.object_key).prepare
  end
end
