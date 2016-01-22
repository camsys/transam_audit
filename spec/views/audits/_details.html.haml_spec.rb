require 'rails_helper'

describe "audits/_details.html.haml", :type => :view do
  it 'info' do
    test_audit = create(:audit)
    assign(:audit, test_audit)
    render

    expect(rendered).to have_content(test_audit.description)
    expect(rendered).to have_content(test_audit.instructions)
  end
end
