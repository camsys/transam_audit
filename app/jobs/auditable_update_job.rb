#------------------------------------------------------------------------------
#
# AuditableUpdateJob
#
# This job is usally created after an auditable asset has been updated and it
# simply runs each operational audit on the asset to update the audit results
#
#------------------------------------------------------------------------------
class AuditableUpdateJob < Job

  attr_accessor :audit
  attr_accessor :auditable

  def run
    if audit.operational?
      audit.auditor.update_status auditable, audit.start_date, audit.end_date, audit.filterable_class_name
    end
  end

  def check
    super
    raise ArgumentError, "audit can't be blank " if audit.blank?
    raise ArgumentError, "auditable can't be blank " if auditable.blank?
  end

  def prepare
    Rails.logger.debug "Executing AuditableUpdateJob at #{Time.now.to_s} for Audit #{audit} and Auditable #{auditable}"
  end



  def initialize(audit, auditable)
    self.audit = audit
    self.auditable = auditable
  end

end
