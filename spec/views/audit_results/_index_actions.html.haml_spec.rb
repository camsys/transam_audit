require 'rails_helper'

describe "audit_results/_index_actions.html.haml", :type => :view do
  it 'links' do
    allow(controller).to receive(:current_ability).and_return(Ability.new(create(:admin)))
    render

    FileContentType.where.not(name: 'New Inventory').each do |file_type|
      expect(rendered).to have_button(file_type.name)
    end
  end
end
