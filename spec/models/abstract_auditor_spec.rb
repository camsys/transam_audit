require 'rails_helper'

RSpec.describe AbstractAuditor do
  let(:abstract_auditor) { AbstractAuditor.new(create(:audit)) }

  it '.write_to_activity_log' do

    # cleanup test data
    Audit.destroy_all
    Activity.destroy_all
    ActivityLog.destroy_all
    User.destroy_all

    test_time = Time.utc(2000,"jan",1,20,15,1)
    allow(Time).to receive(:now).and_return(test_time)

    sys_user = create(:normal_user, :first_name => 'system', :last_name => 'user')
    test_org = create(:organization)
    test_activity = create(:activity)
    abstract_auditor.send(:write_to_activity_log, test_org, test_activity)

    expect(ActivityLog.last.item_type).to eq('AbstractAuditor')
    expect(ActivityLog.last.organization).to eq(test_org)
    expect(ActivityLog.last.activity).to eq(test_activity.id.to_s)
    expect(ActivityLog.last.activity_time).to eq(test_time)
    expect(ActivityLog.last.user).to eq(sys_user)
  end

  it '.system_user' do
    User.destroy_all
    sys_user = create(:normal_user, :first_name => 'system', :last_name => 'user')

    expect(abstract_auditor.send(:system_user)).to eq(sys_user)
  end
end
