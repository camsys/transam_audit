module TransamAuditable
  #-----------------------------------------------------------------------------
  #
  # TransamAuditable
  #
  # Injects methods and associations for auditing objects such as assets
  #
  # Model
  #
  #   The following properties are injected into the Asset Model
  #
  #   has_many    :audit_results, :as => :auditable,    :dependent => :destroy
  #
  #-----------------------------------------------------------------------------
  extend ActiveSupport::Concern

  included do

    # ----------------------------------------------------
    # Call Backs
    # ----------------------------------------------------

    # Run a check before saving to see if any of the asset fields audited are changed
    before_save     :check_for_changes

    # Always check to see if the audit needs to be checked
    after_save      :update_audits

    # Set a local instance variable to determine if the audit needs to be updated
    attr_accessor   :is_dirty

    # ----------------------------------------------------
    # Associations
    # ----------------------------------------------------

    # Each object has zero or more audit results. Audit results are deleted when the object is deleted
    has_many    :audit_results, :as => :auditable,    :dependent => :destroy

    # ----------------------------------------------------
    # Validations
    # ----------------------------------------------------

  end

  #-----------------------------------------------------------------------------
  # Class Methods
  #-----------------------------------------------------------------------------

  module ClassMethods

  end

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Returns a list of audits that this asset has participated in that are
  # both currently active and operational
  #-----------------------------------------------------------------------------
  def audits
    Audit.active.where(:id => audit_results.pluck(:audit_id).uniq)
  end

  #-----------------------------------------------------------------------------
  # Protected Methods
  #-----------------------------------------------------------------------------
  protected

  def check_for_changes
    Rails.logger.debug "checking for audit changes"
    self.is_dirty = false
    audits.each do |audit|
      if audit.operational? and audit.auditor.detect_changes? self
        self.is_dirty = true
        break
      end
    end
  end

  #-----------------------------------------------------------------------------
  # Each operational audit is re-run after a save event on the asset
  #-----------------------------------------------------------------------------
  def update_audits
    if self.is_dirty
      Rails.logger.debug "In update_audits callback"
      audits.each do |audit|
          job = AssetAuditUpdateJob.new(audit, object_key)
          Delayed::Job.enqueue job, :priority => 0
      end
    end
  end

end
