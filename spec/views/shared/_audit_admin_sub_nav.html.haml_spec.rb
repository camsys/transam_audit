require 'rails_helper'

describe "shared/_audit_admin_sub_nav.html.haml", :type => :view do
  it 'links' do
    allow(controller).to receive(:current_ability).and_return(Ability.new(create(:admin)))
    render

    expect(rendered).to have_link('Audits')
  end
end
