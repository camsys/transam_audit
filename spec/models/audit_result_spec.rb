require 'rails_helper'

RSpec.describe AuditResult, :type => :model do

  let(:test_asset) { create(:buslike_asset) }
  let(:test_result) { create(:audit_result, :auditable_id => test_asset.id, :organization => test_asset.organization) }

  describe 'associations' do
    it 'has an auditable object' do
      expect(AuditResult.column_names).to include('auditable_id')
    end
    it 'belongs to an audit' do
      expect(AuditResult.column_names).to include('audit_id')
    end
    it 'has an org' do
      expect(AuditResult.column_names).to include('organization_id')
    end
    it 'has a type' do
      expect(AuditResult.column_names).to include('audit_result_type_id')
    end
  end

  it '#allowable_params' do
    expect(AuditResult.allowable_params).to eq([])
  end

  it '.to_s' do

  end
  it '.path' do
    expect(test_result.path).to eq("asset_path(:id => '#{test_asset.object_key}')")
  end

end
