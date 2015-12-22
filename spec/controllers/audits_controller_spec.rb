require 'rails_helper'

RSpec.describe AuditsController, :type => :controller do

  class TestOrg < Organization
    def get_policy
      return Policy.where("`organization_id` = ?",self.id).order('created_at').last
    end
  end

  let(:test_audit) { create(:audit) }

  before(:each) do
    sign_in FactoryGirl.create(:admin)
  end

  it 'GET index' do
    get :index

    expect(assigns(:audits)).to eq(Audit.all.order("name, created_at DESC"))
  end

  it 'GET show' do
    get :show, :id => test_audit.object_key

    expect(assigns(:audit)).to eq(test_audit)
  end

  it 'GET new' do
    get :new

    expect(assigns(:audit).to_json).to eq(Audit.new.to_json)
  end
  it 'GET edit' do
    get :edit, :id => test_audit.object_key

    expect(assigns(:audit)).to eq(test_audit)
  end

  it 'POST create' do
    Audit.destroy_all
    post :create, :audit => attributes_for(:audit)

    expect(Audit.count).to eq(1)
  end
  it 'PUT update' do
    put :update, :id => test_audit.object_key, :audit => {:instructions => 'new instructions 222'}
    test_audit.reload

    expect(test_audit.instructions).to eq('new instructions 222')
  end

  it 'DELETE destroy' do
    delete :destroy, :id => test_audit.object_key

    expect(Audit.find_by(:object_key => test_audit.object_key)).to be nil
  end

  describe 'negative tests' do
    it 'audit does not exist' do
      get :show, :id => 'ABCDEFGHIJ'

      expect(response).to redirect_to('/404')
    end
  end

end
