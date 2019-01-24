class RemoveOldAuditResultsAndRerun < ActiveRecord::DataMigration
  def up
    AuditResult.where(filterable_type: nil).destroy_all
    Audit.last.auditor.audit
  end
end