require 'rails_helper'

describe "shared/_audit_policy_sub_nav.html.haml", :type => :view do
  it 'single audit results' do
    test_audit = create(:audit)
    render

    expect(rendered).to have_link("#{test_audit.name} Results")
  end
  it 'all results' do
    render

    expect(rendered).to have_link('All Audit Results')
  end
end
