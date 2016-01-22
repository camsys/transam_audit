require 'rails_helper'

describe "audits/index.html.haml", :type => :view do
  it 'no audits' do
    allow(controller).to receive(:current_ability).and_return(Ability.new(create(:admin)))

    assign(:audits, [])
    render

    expect(rendered).to have_content('No matching audits found')
  end
  it 'audits' do
    test_user = create(:admin)
    allow(controller).to receive(:current_user).and_return(test_user)
    allow(controller).to receive(:current_ability).and_return(Ability.new(test_user))
    assign(:audits, [create(:audit)])
    render

    expect(rendered).to have_content('Found 1 matching audits')
  end
end
