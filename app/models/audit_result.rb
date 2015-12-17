#-------------------------------------------------------------------------------
# AuditResult
#
# An object can be audited by an auditor job. The results of the audit are stored
# in this class.
#
# To use this class as an association with another class include the following line into
# the model
#
# has_many    :audit_results,  :as => :auditable, :dependent => :destroy
#
#-------------------------------------------------------------------------------

class AuditResult < ActiveRecord::Base

  #-----------------------------------------------------------------------------
  # Callbacks
  #-----------------------------------------------------------------------------
  after_initialize  :set_defaults

  #-----------------------------------------------------------------------------
  # Associations
  #-----------------------------------------------------------------------------
  # Every audit result belongs to another object
  belongs_to :auditable,  :polymorphic => true

  # Each audit result belongs to an audit
  belongs_to :audit

  # Each audit result belongs to an organizaiton
  belongs_to :organization

  # Each audit result has a status type
  belongs_to :audit_result_type

  #-----------------------------------------------------------------------------
  # Scopes
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Constants
  #-----------------------------------------------------------------------------
  # List of hash parameters allowed by the controller. As audits are only created
  # by audit jobs there are no form params needed
  FORM_PARAMS = [
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

  # Return the Rails path to this object
	def path
		"#{auditable_type.underscore}_path(:id => '#{auditable.object_key}')"
	end

  #-----------------------------------------------------------------------------
  # Protected Methods
  #-----------------------------------------------------------------------------
  protected

  # Set resonable defaults for a new asset event
  def set_defaults

  end

  #-----------------------------------------------------------------------------
  # Private Methods
  #-----------------------------------------------------------------------------
  private

end
