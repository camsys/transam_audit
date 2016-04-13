require 'rails_helper'

describe "audits/_index_table.html.haml", :type => :view do
  it 'list' do
    allow(controller).to receive(:current_user).and_return(create(:admin))
    test_audit = create(:audit, :activity => create(:activity))
    render 'audits/index_table', :audits => [test_audit]

    expect(rendered).to have_link(test_audit.name)
    expect(rendered).to have_content(test_audit.description)
    expect(rendered).to have_content(test_audit.instructions)
    # expect(rendered).to have_link(test_audit.activity.to_s)
  end
end
