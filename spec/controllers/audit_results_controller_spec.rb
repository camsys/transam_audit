require 'rails_helper'

RSpec.describe AuditResultsController, :type => :controller do

  class TestOrg < Organization
    def get_policy
      return Policy.where("`organization_id` = ?",self.id).order('created_at').last
    end
  end

  before(:each) do
    test_user = create(:admin)
    test_user.organizations << test_user.organization
    test_user.save!
    sign_in test_user
  end

  it 'GET index' do
    test_asset = create(:buslike_asset, :organization => subject.current_user.organization)
    test_result = create(:audit_result, :auditable => test_asset, :audit_result_type_id => 2, :organization => test_asset.organization)


    get :index, :org_filter => subject.current_user.organization.id, :types_filter => ['Asset'], :audit_filter => test_result.audit.id

    expect(assigns(:org_filter)).to eq(subject.current_user.organization.id.to_s)
    expect(assigns(:types_filter)).to eq(['Asset'])
    expect(assigns(:audit_filter)).to eq(test_result.audit.id.to_s)
    expect(assigns(:audit_result_type_filter)).to eq([2])
    expect(assigns(:audit_results)).to include(test_result)
    expect(assigns(:types)).to include(test_result.class_name)
  end

end