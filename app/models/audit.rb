#-------------------------------------------------------------------------------
# Audit
#
# This is a base audit class that represents an audit that can be performed
# on objects in TransAM. The results of an audit are stored in the AuditResult
# class.
#
# Audits are usually associated with an Activity and run via an auditor job
#
#-------------------------------------------------------------------------------

class Audit < ActiveRecord::Base

  # Include the object key mixin
  include TransamObjectKey

  #-----------------------------------------------------------------------------
  # Callbacks
  #-----------------------------------------------------------------------------
  after_initialize  :set_defaults

  #-----------------------------------------------------------------------------
  # Associations
  #-----------------------------------------------------------------------------
  # Each audit can have many audit results
  has_many  :audit_results

  # Each audit belongs to an auditor activity
  belongs_to :activity

  #-----------------------------------------------------------------------------
  # Scopes
  #-----------------------------------------------------------------------------
  scope :active, -> { where(:active => true) }

  #-----------------------------------------------------------------------------
  # Constants
  #-----------------------------------------------------------------------------
  # List of hash parameters allowed by the controller. As audits are only created
  # by audit jobs there are no form params needed
  FORM_PARAMS = [
    :activity_id,
    :name,
    :description,
    :instructions,
    :schedule,
    :auditor_class_name,
    :active
  ]

  #-----------------------------------------------------------------------------
  # Class Methods
  #-----------------------------------------------------------------------------
  def self.allowable_params
    FORM_PARAMS
  end

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------
  def to_s
    name
  end

  # Return an instance of the auditor class
  def auditor
    auditor_class_name.constantize.new(self)
  end

  # Pass-through the operational? method to the activity
  def operational?
    if activity.present?
      activity.operational?
    else
      false
    end
  end
  #-----------------------------------------------------------------------------
  # Protected Methods
  #-----------------------------------------------------------------------------
  protected

  # Set resonable defaults for a new asset event
  def set_defaults
    self.active ||= true
  end

  #-----------------------------------------------------------------------------
  # Private Methods
  #-----------------------------------------------------------------------------
  private

end
