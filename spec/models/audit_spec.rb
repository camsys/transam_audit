require 'rails_helper'

RSpec.describe Audit, :type => :model do

  let(:test_audit) { create(:audit, :activity => create(:activity)) }

  describe 'associations' do
    it 'has many results' do
      expect(test_audit).to have_many(:audit_results)
    end
  end

  describe 'validations' do
    it 'must have a name' do
      test_audit.name = nil
      expect(test_audit.valid?).to be false
    end
    it 'must have a description' do
      test_audit.description = nil
      expect(test_audit.valid?).to be false
    end
    it 'must have instructions' do
      test_audit.instructions = nil
      expect(test_audit.valid?).to be false
    end
    it 'must have an auditor class' do
      test_audit.auditor_class_name = nil
      expect(test_audit.valid?).to be false
    end
    it 'must have a start date' do
      test_audit.start_date = nil
      expect(test_audit.valid?).to be false
    end
    it 'must have an end date' do
      test_audit.end_date = nil
      expect(test_audit.valid?).to be false
    end
  end

  it '#allowable_params' do
    expect(Audit.allowable_params).to eq([
      :activity_id,
      :name,
      :description,
      :instructions,
      :start_date,
      :end_date,
      :auditor_class_name,
      :active,
      :filterable_class_name,
      :activity_attributes=>[:id, :show_in_dashboard, :start_date, :end_date, :frequency_type_id, :active]
    ])
  end

  it '.to_s' do
    expect(test_audit.to_s).to eq(test_audit.name)
  end

  it '.auditor' do
    expect(test_audit.auditor.to_json).to eq(AssetAuditor.new(test_audit).to_json)
  end

  describe '.operational?' do
    it 'no activity' do
      test_audit.activity = nil
      expect(test_audit.operational?).to be false
    end
    describe 'not active' do
      before(:each) do
        test_audit.active = false
      end
      describe 'activity.operational? is' do
        it 'false' do
          test_audit.activity.update!(:start_date => Date.today - 5.days, :end_date => Date.today - 3.days)
          expect(test_audit.activity.operational?).to be false
          expect(test_audit.operational?).to be false
        end
        it 'true' do
          test_audit.activity.update!(:start_date => Date.today - 3.days, :end_date => Date.today + 3.days)
          expect(test_audit.activity.operational?).to be true
          expect(test_audit.operational?).to be false
        end
      end
    end
    describe 'matches activity.operational?' do
      it 'false' do
        test_audit.activity.update!(:start_date => Date.today - 5.days, :end_date => Date.today - 3.days)
        expect(test_audit.operational?).to be false
      end
      it 'true' do
        test_audit.activity.update!(:start_date => Date.today - 3.days, :end_date => Date.today + 3.days)
        expect(test_audit.operational?).to be true
      end
    end
  end

  it '.set_defaults' do
    expect(Audit.new.active).to be true
  end
end
