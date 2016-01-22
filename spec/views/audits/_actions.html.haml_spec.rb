require 'rails_helper'

describe "audits/_actions.html.haml", :type => :view do
  it 'actions' do
    allow(controller).to receive(:current_ability).and_return(Ability.new(create(:admin)))
    assign(:audit, create(:audit))
    render


    expect(rendered).to have_link('Update this audit')
    expect(rendered).to have_link('Remove this audit')
  end
end
