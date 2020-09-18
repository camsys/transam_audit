require 'rails_helper'

describe "shared/_audit_policy_sub_nav.html.haml", :type => :view do
  it 'all results' do
    render

    expect(rendered).to have_link('All Audit Results')
  end
end
