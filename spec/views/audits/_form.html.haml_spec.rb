require 'rails_helper'

describe "audits/_form.html.haml", :type => :view do
  it 'fields' do
    assign(:audit, create(:audit))
    render

    expect(rendered).to have_field('audit_name')
    #expect(rendered).to have_field('audit_auditor_class_name') # disabled class since no interactive audit creating
    expect(rendered).to have_field('audit_activity_attributes_start_date')
    expect(rendered).to have_field('audit_activity_attributes_end_date')
    expect(rendered).to have_field('audit_activity_attributes_show_in_dashboard')
    expect(rendered).to have_field('audit_activity_attributes_active')
    expect(rendered).to have_field('audit_start_date')
    expect(rendered).to have_field('audit_end_date')
    expect(rendered).to have_field('audit_active')
    expect(rendered).to have_field('audit_description')
    expect(rendered).to have_field('audit_instructions')
  end
end
