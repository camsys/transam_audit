require 'rails_helper'

RSpec.describe AuditResult, :type => :model do

  let(:test_subtype) { create(:asset_subtype)}
  let(:test_parent_policy) { create(:parent_policy, type: test_subtype.asset_type_id, subtype: test_subtype.id) }
  let(:test_policy) { create(:policy, organization: test_parent_policy.organization, parent: test_parent_policy) }
  let(:test_asset) { create(:buslike_asset, asset_subtype: test_subtype, organization: test_policy.organization) }
  let(:test_result) { create(:audit_result, :auditable_id => test_asset.id, :organization => test_asset.organization) }

  describe 'associations' do
    it 'has an auditable object' do
      expect(test_result).to belong_to(:auditable)
    end
    it 'belongs to an audit' do
      expect(test_result).to belong_to(:audit)
    end
    it 'has an org' do
      expect(test_result).to belong_to(:organization)
    end
    it 'has a type' do
      expect(test_result).to belong_to(:audit_result_type)
    end
  end

  describe 'validations' do
    it 'must belong to an audit' do
      test_result.audit = nil
      expect(test_result.valid?).to be false
    end
    it 'must have an org' do
      test_result.organization = nil
      expect(test_result.valid?).to be false
    end
    it 'must have a type' do
      test_result.audit_result_type = nil
      expect(test_result.valid?).to be false
    end
  end

  it '#allowable_params' do
    expect(AuditResult.allowable_params).to eq([])
  end

  it '.to_s' do

  end
  it '.path' do
    expect(test_result.path).to eq("inventory_path(:id => '#{test_asset.object_key}')")
  end

end
