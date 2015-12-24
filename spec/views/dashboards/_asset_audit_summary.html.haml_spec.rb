require 'rails_helper'

describe "dashboards/_asset_audit_summary.html.haml", :type => :view do
  it 'no audits' do
    Audit.destroy_all
    render

    expect(rendered).to have_content('No active audits found')
  end

  it 'audits' do
    test_audit = create(:audit)
    assign(:organization_list, [create(:organization)])
    render

    expect(rendered).to have_content("#{test_audit.name} Results")
  end
end
