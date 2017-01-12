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
  # Validations
  #-----------------------------------------------------------------------------
  validates :audit,                    :presence => true
  validates :organization,             :presence => true
  validates :audit_result_type,        :presence => true

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

  def self.search_auditable(audit_results_criteria, type=nil,audited_must_meet={}, audited_must_not_meet={})
    # there are always conditions on audit results
    # make keys .to_sym
    audit_results_criteria = audit_results_criteria.symbolize_keys!

    if type.nil? || (audited_must_meet.empty? and audited_must_not_meet.empty?)
      return where(audit_results_criteria)
    end

    if audit_results_criteria[:auditable_type].blank?
      audit_results_criteria[:auditable_type] = type
    end

    audited_table = type.downcase.pluralize

    audit_results =
      joins( "INNER JOIN `#{audited_table}` ON `audit_results`.`auditable_id` = `#{audited_table}`.`id`" )
      .where( :audit_results => audit_results_criteria )

    unless audited_must_meet.empty?
      audit_results = audit_results.where( audited_table.to_sym => audited_must_meet )
    end

    unless audited_must_not_meet.empty?
      audit_results = audit_results.where.not( audited_table.to_sym => audited_must_not_meet )
    end

    return audit_results
  end

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------
  def to_s
    "#{auditable} #{audit_result_type}"
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
