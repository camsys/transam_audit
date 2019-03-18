class RemoveOldAuditResultsAndRerun < ActiveRecord::DataMigration
  def up
    AuditResult.where(filterable_type: nil).destroy_all
    Audit.active.last.auditor.audit if Audit.active.last.present?
  end
end