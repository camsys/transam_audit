require 'rails_helper'

describe "audits/_summary.html.haml", :type => :view do
  it 'info' do
    test_audit = create(:audit, :activity => create(:activity))
    render 'audits/summary', :audit => test_audit

    expect(rendered).to have_content(test_audit.name)
    expect(rendered).to have_link(test_audit.activity.to_s)
    expect(rendered).to have_content(test_audit.auditor_class_name)
    expect(rendered).to have_content(test_audit.schedule)
  end
end
