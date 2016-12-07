#------------------------------------------------------------------------------
#
# AuditUpdateJob
#
# Runs a single audit
#
#------------------------------------------------------------------------------
class AuditUpdateJob < Job

  attr_accessor :audit
  attr_accessor :creator

  def run

    audit.auditor.audit

    event_url = Rails.application.routes.url_helpers.audit_results_path
    audit_notification = Notification.create(text: "#{audit.name} has been run with new Data Update Start Date and End Date.", link: event_url)
    UserNotification.create(user: creator, notification: audit_notification)

  end

  def prepare
    Rails.logger.debug "Executing AuditUpdateJob at #{Time.now.to_s}"
  end

  def check
    raise ArgumentError, "audit can't be blank " if audit.nil?
    raise ArgumentError, "creator can't be blank " if creator.nil?
  end

  def initialize(audit, creator)
    super
    self.audit = audit
    self.creator = creator
  end

end
