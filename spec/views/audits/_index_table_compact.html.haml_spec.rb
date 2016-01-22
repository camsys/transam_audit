require 'rails_helper'

describe "audits/_index_table_compact.html.haml", :type => :view do
  it 'list' do
    test_audit = create(:audit, :activity => create(:activity))
    render 'audits/index_table_compact', :audits => [test_audit]

    expect(rendered).to have_link(test_audit.name)
    expect(rendered).to have_link(test_audit.activity.to_s)
  end
end
