require 'rails_helper'

RSpec.describe AssetAuditor do

  class TestOrg < Organization
    def get_policy
      return Policy.where("`organization_id` = ?",self.id).order('created_at').last
    end
  end

  class Vehicle < Asset
    has_many :mileage_updates
  end

  let(:test_asset) { create(:buslike_asset) }

  before(:each) do
    Activity.destroy_all
    Audit.destroy_all
    AuditResult.destroy_all
  end

  describe '.update_status' do
    it 'no asset' do
      expect(Rails.logger).to receive(:debug).with("Asset cannot be nil")
      AssetAuditor.new(create(:activity)).send(:update_status, nil)
    end
    it 'disposed asset' do
      test_asset.update!(:disposition_date => Date.today)
      expect(AssetAuditor.new(create(:activity)).send(:update_status, test_asset)).to eq([])
    end
    it 'condition' do
      AssetAuditor.new(create(:activity)).send(:update_status, test_asset)
      test_result = AuditResult.find_by(:auditable => test_asset)
      expect(test_result.audit_result_type_id).to eq(AuditResultType::AUDIT_RESULT_FAILED)
      expect(test_result.notes).to include('Condition has not been updated during the audit period')
    end
    it 'service status' do
      AssetAuditor.new(create(:activity)).send(:update_status, test_asset)
      test_result = AuditResult.find_by(:auditable => test_asset)
      expect(test_result.audit_result_type_id).to eq(AuditResultType::AUDIT_RESULT_FAILED)
      expect(test_result.notes).to include('Service Status has not been updated during the audit period')
    end
    it 'mileage' do
      AssetAuditor.new(create(:activity)).send(:update_status, test_asset)
      test_result = AuditResult.find_by(:auditable => test_asset)
      expect(test_result.audit_result_type_id).to eq(AuditResultType::AUDIT_RESULT_FAILED)
      expect(test_result.notes).to include('Mileage has not been updated during the audit period')
    end
    it 'passed audit result' do
      test_asset.update!(:reported_condition_date => Date.today, :service_status_date => Date.today, :reported_mileage_date => Date.today)
      AssetAuditor.new(create(:activity)).send(:update_status, test_asset)
      test_result = AuditResult.find_by(:auditable => test_asset)
      expect(test_result.audit_result_type_id).to eq(AuditResultType::AUDIT_RESULT_PASSED)
    end
  end
end