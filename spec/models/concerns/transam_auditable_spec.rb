require 'rails_helper'

RSpec.describe TransamAuditable do
  it '.audits' do
      test_audit = create(:audit)
      test_subtype = create(:asset_subtype)
      test_parent_policy = create(:parent_policy, type: test_subtype.asset_type_id, subtype: test_subtype.id)
      test_policy = create(:policy, organization: test_parent_policy.organization, parent: test_parent_policy)
      test_asset = create(:buslike_asset, asset_subtype: test_subtype, organization: test_parent_policy.organization)
      test_audit_result = create(:audit_result, :auditable => test_asset, :audit => test_audit, :organization => test_asset.organization)

      test_audit2 = create(:audit)
      test_subtype2 = create(:asset_subtype)
      test_parent_policy2 = create(:parent_policy, type: test_subtype.asset_type_id, subtype: test_subtype.id)
      test_policy2 = create(:policy, organization: test_parent_policy.organization, parent: test_parent_policy)
      test_asset2 = create(:buslike_asset, asset_subtype: test_subtype, organization: test_parent_policy.organization)
      test_audit_result2 = create(:audit_result, :auditable => test_asset2, :audit => test_audit2, :organization => test_asset2.organization)

      expect(test_asset.audits).to include(test_audit)
      expect(test_asset.audits).not_to include(test_audit2)
  end
end
