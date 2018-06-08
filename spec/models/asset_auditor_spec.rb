require 'rails_helper'

RSpec.describe AssetAuditor do

  let(:test_asset) { create(:buslike_asset, :service_status_type_id => 1) }
  let(:test_audit) { create(:audit) }

  before(:each) do
    Activity.destroy_all
    Audit.destroy_all
    AuditResult.destroy_all
  end

  describe '.update_status' do
    it 'no asset' do
      asset_auditor = AssetAuditor.new(test_audit)
      expect(Rails.logger).to receive(:debug).with("Asset cannot be nil")
      asset_auditor.update_status(nil, test_audit.start_date, test_audit.end_date)
    end
    it 'disposed asset' do
      test_asset.update!(:disposition_date => Date.today)
      expect(AssetAuditor.new(test_audit).send(:update_status, test_asset, test_audit.start_date, test_audit.end_date)).to eq([])
    end
    it 'condition' do
      AssetAuditor.new(test_audit).send(:update_status, test_asset, test_audit.start_date, test_audit.end_date)
      test_result = AuditResult.find_by(:auditable => test_asset)
      expect(test_result.audit_result_type_id).to eq(AuditResultType::AUDIT_RESULT_FAILED)
      expect(test_result.notes).to include('Condition has not been updated during the audit period')
    end
    it 'service status' do
      AssetAuditor.new(test_audit).send(:update_status, test_asset, test_audit.start_date, test_audit.end_date)
      test_result = AuditResult.find_by(:auditable => test_asset)
      expect(test_result.audit_result_type_id).to eq(AuditResultType::AUDIT_RESULT_FAILED)
      expect(test_result.notes).to include('Service Status has not been updated during the audit period')
    end
    it 'mileage' do
      AssetAuditor.new(test_audit).send(:update_status, Vehicle.find(test_asset.id), test_audit.start_date, test_audit.end_date)
      test_result = AuditResult.find_by(:auditable => test_asset)
      expect(test_result.audit_result_type_id).to eq(AuditResultType::AUDIT_RESULT_FAILED)
      expect(test_result.notes).to include('Mileage has not been updated during the audit period')
    end
    it 'passed audit result' do
      test_asset.condition_updates.create!(attributes_for(:condition_update_event))
      test_asset.service_status_updates.create!(attributes_for(:service_status_update_event))

      AssetAuditor.new(test_audit).send(:update_status, test_asset, test_audit.start_date, test_audit.end_date)
      test_result = AuditResult.find_by(:auditable => test_asset)
      expect(test_result.audit_result_type_id).to eq(AuditResultType::AUDIT_RESULT_PASSED)
    end
    it 'passed audit result if on start date' do
      test_asset.condition_updates.create!(attributes_for(:condition_update_event, :event_date => test_audit.start_date))
      test_asset.service_status_updates.create!(attributes_for(:service_status_update_event, :event_date => test_audit.start_date))

      AssetAuditor.new(test_audit).send(:update_status, test_asset, test_audit.start_date, test_audit.end_date)
      test_result = AuditResult.find_by(:auditable => test_asset)
      expect(test_result.audit_result_type_id).to eq(AuditResultType::AUDIT_RESULT_PASSED)
    end
    it 'passed audit result if on end date' do
      test_asset.condition_updates.create!(attributes_for(:condition_update_event, :event_date => test_audit.end_date))
      test_asset.service_status_updates.create!(attributes_for(:service_status_update_event, :event_date => test_audit.end_date))

      AssetAuditor.new(test_audit).send(:update_status, test_asset, test_audit.start_date, test_audit.end_date)
      test_result = AuditResult.find_by(:auditable => test_asset)
      expect(test_result.audit_result_type_id).to eq(AuditResultType::AUDIT_RESULT_PASSED)
    end
  end
end
