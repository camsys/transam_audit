require 'rails_helper'

describe "audit_results/_index_table_compact.html.haml", :type => :view do
  it 'list' do
    test_subtype = create(:asset_subtype)
    test_parent_policy = create(:parent_policy, type: test_subtype.asset_type_id, subtype: test_subtype.id)
    test_policy = create(:policy, organization: test_parent_policy.organization, parent: test_parent_policy)
    test_asset = create(:buslike_asset, asset_subtype: test_subtype, organization: test_parent_policy.organization)
    test_result = create(:audit_result, :auditable => test_asset, :organization => test_asset.organization, :notes => 'notes 123')
    assign(:organization_list, [test_asset.organization, create(:organization)])
    render 'audit_results/index_table_compact', :audit_results => [test_result]

    expect(rendered).to have_content(test_result.audit.to_s)
    expect(rendered).to have_content(test_result.audit_result_type.to_s)
    expect(rendered).to have_content('notes 123')
  end
end
