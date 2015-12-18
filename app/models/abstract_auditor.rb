#-------------------------------------------------------------------------------
# AbstractAuditor
#
# Base class for auditors
#-------------------------------------------------------------------------------
class AbstractAuditor

  # Every auditor has an audit context
  attr_accessor :context

  #-----------------------------------------------------------------------------
  #
  #-----------------------------------------------------------------------------
  def initialize(audit)
    self.context = audit
  end

  #-----------------------------------------------------------------------------
  protected
  #-----------------------------------------------------------------------------

  # Write to activity log
  def write_to_activity_log org, message
    log = ActivityLog.new({
      :item_type => self.class.name,
      :organization => org,
      :activity => message,
      :activity_time => Time.now,
      :user => system_user
      })
    log.save
  end

  # Get the system user
  def system_user
    User.find_by('first_name = ? AND last_name = ?', 'system', 'user')
  end

end
