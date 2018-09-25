class CleanoutAuditResultsAssets < ActiveRecord::DataMigration
  def up
    AuditResult.destroy_all
    # re-run all
    Audit.all.each do |audit|
      job = AuditUpdateJob.new(audit, User.find_by(first_name: 'system'))
      Delayed::Job.enqueue job, :priority => 0
    end
  end
end