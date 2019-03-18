require 'rails_helper'

describe "audit_results/index.html.haml", :type => :view do
  it 'no results' do
    assign(:organization_list, [create(:organization).id])
    assign(:types, ['Asset'])
    assign(:audit_results, [])
    assign(:auditable_type, 'TransamAsset')
    assign(:filterables, [nil, nil])
    assign(:filterable_filter, [nil, nil])
    render

    expect(rendered).to have_content('No matching audit results found')
  end
  it 'found results' do
    allow(controller).to receive(:current_user).and_return(create(:admin))
    test_subtype = create(:asset_subtype)
    test_parent_policy = create(:parent_policy, type: test_subtype.asset_type_id, subtype: test_subtype.id)
    test_policy = create(:policy, organization: test_parent_policy.organization, parent: test_parent_policy)
    test_asset = create(:buslike_asset, asset_subtype: test_subtype, organization: test_parent_policy.organization)
    assign(:audit_results, [create(:audit_result, :auditable => test_asset, :organization => test_asset.organization)])
    assign(:organization_list, [create(:organization).id])
    assign(:types, ['Asset'])
    assign(:auditable_type, 'TransamAsset')
    assign(:filterables, [test_asset.asset_type.name, test_asset.asset_type_id])
    assign(:filterable_filter, [test_asset.asset_type.name, test_asset.asset_type_id])

    render

    expect(rendered).to have_content('Found 1 matching results')
  end
end
