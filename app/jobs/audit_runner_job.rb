#-------------------------------------------------------------------------------
# AuditRunnerJob
#
# Activity Job runner that runs an audit. The activity is set as the run time
# context. This is used to get the corresponding audit from the audit table
#-------------------------------------------------------------------------------
class AuditRunnerJob < ActivityJob

  def run

    # Get the audit(s) for this activity -- there could be more than one
    # associated with teh activity
    Audit.active.where(:activity => context).each do |audit|
      audit.auditor.audit
    end

  end

  def clean_up
    super
    Rails.logger.debug "Completed AuditRunnerJob at #{Time.now.to_s}"
  end

  def prepare
    super
    Rails.logger.debug "Executing AuditRunnerJob at #{Time.now.to_s}"
  end
end
