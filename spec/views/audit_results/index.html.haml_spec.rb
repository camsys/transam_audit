require 'rails_helper'

describe "audit_results/index.html.haml", :type => :view do
  it 'no results' do
    assign(:organization_list, [create(:organization).id])
    assign(:types, ['Asset'])
    assign(:audit_results, [])
    assign(:auditable_type, 'Asset')
    render

    expect(rendered).to have_content('No matching audit results found')
  end
  it 'found results' do
    allow(controller).to receive(:current_user).and_return(create(:admin))
    test_asset = create(:buslike_asset)
    assign(:audit_results, [create(:audit_result, :auditable => test_asset, :organization => test_asset.organization)])
    assign(:organization_list, [create(:organization).id])
    assign(:types, ['Asset'])
    assign(:auditable_type, 'Asset')
    render

    expect(rendered).to have_content('Found 1 matching results')
  end
end
