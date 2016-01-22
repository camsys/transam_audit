require 'rails_helper'

describe "audits/_form.html.haml", :type => :view do
  it 'fields' do
    assign(:audit, Audit.new)
    render

    expect(rendered).to have_field('audit_name')
    expect(rendered).to have_field('audit_auditor_class_name')
    expect(rendered).to have_field('audit_activity_id')
    expect(rendered).to have_field('audit_schedule')
    expect(rendered).to have_field('audit_active')
    expect(rendered).to have_field('audit_description')
    expect(rendered).to have_field('audit_instructions')
  end
end
