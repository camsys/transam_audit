require 'rails_helper'

describe "audit_results/_index_actions.html.haml", :type => :view do
  it 'links' do
    render

    FileContentType.all.each do |file_type|
      expect(rendered).to have_link(file_type.name)
    end
  end
end
