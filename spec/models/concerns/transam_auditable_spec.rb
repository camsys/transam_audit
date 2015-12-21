require 'rails_helper'

RSpec.describe TransamAuditable do
  it '.audits' do
      test_audit = create(:audit)
      test_asset = create(:buslike_asset)
      test_audit_result = create(:audit_result, :auditable => test_asset, :audit => test_audit, :organization => test_asset.organization)

      test_audit2 = create(:audit)
      test_asset2 = create(:buslike_asset)
      test_audit_result2 = create(:audit_result, :auditable => test_asset2, :audit => test_audit2, :organization => test_asset2.organization)

      expect(test_asset.audits).to include(test_audit)
      expect(test_asset.audits).not_to include(test_audit2)
  end
end
