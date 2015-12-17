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
    # Always check to see if the audit needs to be checked
    after_save  :update_audits

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

  # Returns a list of audits that this asset has participated in that are
  # both currently active and operational
  def audits
    Audit.active.where(:id => audit_results.pluck(:audit_id).uniq)
  end

  #-----------------------------------------------------------------------------
  # Protected Methods
  #-----------------------------------------------------------------------------
  protected

  # Each operational audit is re-run
  def update_audits
    job = KeywordIndexUpdateJob.new(self.class.name, object_key)
    Delayed::Job.enqueue job, :priority => 10
    self.is_dirty = false
  end

end
