require 'rails_helper'

RSpec.describe AuditRunnerJob, :type => :job do

  let(:test_activity) { create(:activity) }

  it '.run' do

    Asset.destroy_all
    AuditResult.destroy_all
    test_asset = create(:buslike_asset, :service_status_type_id => 1)

    test_audit = create(:audit, :activity => test_activity)
    AuditRunnerJob.new({:context => test_activity}).run

    expect(AuditResult.where('auditable_id = ?', test_asset.id).count).to eq(1)
  end

  it '.clean_up' do
    test_activity.save!
    allow(Time).to receive(:now).and_return(Time.utc(2000,"jan",1,20,15,1))

    expect(Rails.logger).to receive(:debug).with("Completed AuditRunnerJob at #{Time.now.to_s}")
    AuditRunnerJob.new({:context => test_activity}).clean_up

  end
  it '.prepare' do
    test_activity.save!
    allow(Time).to receive(:now).and_return(Time.utc(2000,"jan",1,20,15,1))

    expect(Rails.logger).to receive(:debug).with("Executing AuditRunnerJob at #{Time.now.to_s}")
    AuditRunnerJob.new({:context => test_activity}).prepare
  end

end
