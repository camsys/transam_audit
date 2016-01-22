require 'rails_helper'

describe "audit_results/_search_form.html.haml", :type => :view do
  it 'fields' do
    create(:audit)
    test_org = create(:organization)
    assign(:organization_list, [test_org.id, create(:organization).id])
    assign(:types, ['Asset'])
    assign(:types_filter, 'Asset')
    assign(:audit_result_type_filter, 2)
    assign(:audit_filter, 1)
    render

    expect(rendered).to have_field('org_filter')
    expect(rendered).to have_field('types_filter')
    expect(rendered).to have_field('audit_result_type_filter')
    expect(rendered).to have_field('audit_filter')
  end
end
