require 'rails_helper'

RSpec.describe Audit, :type => :model do

  let(:test_audit) { create(:audit, :activity => create(:activity)) }

  describe 'associations' do
    it 'has many results' do
      expect(AuditResult.column_names).to include('audit_id')
    end
  end

  it '#allowable_params' do
    expect(Audit.allowable_params).to eq([
      :activity_id,
      :name,
      :description,
      :instructions,
      :schedule,
      :auditor_class_name,
      :active
    ])
  end

  it '.to_s' do
    expect(test_audit.to_s).to eq(test_audit.name)
  end

  it '.auditor' do
    expect(test_audit.auditor.to_json).to eq(AssetAuditor.new(test_audit).to_json)
  end

  describe '.operational?' do
    it 'no activity' do
      test_audit.activity = nil
      expect(test_audit.operational?).to be false
    end
    describe 'matches activity.operational?' do
      it 'false' do
        test_audit.activity = nil
        expect(test_audit.operational?).to be false
      end
      it 'true' do
        test_audit.activity.update!(:start_date => Date.today - 3.days, :end_date => Date.today + 3.days)
        expect(test_audit.operational?).to be true
      end
    end
  end

  it '.set_defaults' do
    expect(Audit.new.active).to be true
  end
end