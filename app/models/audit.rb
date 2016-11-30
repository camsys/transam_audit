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

  # Allow the form to submit grant purchases
  accepts_nested_attributes_for :activity, update_only: true

  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------
  validates :name,                    :presence => true
  validates :activity,                :presence => true
  validates :auditor_class_name,      :presence => true
  validates :start_date,              :presence => true
  validates :end_date,                :presence => true
  validates :description,             :presence => true
  validates :instructions,            :presence => true

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
    :start_date,
    :end_date,
    :auditor_class_name,
    :active
  ]

  #-----------------------------------------------------------------------------
  # Class Methods
  #-----------------------------------------------------------------------------
  def self.allowable_params
    FORM_PARAMS +
    [
      :activity_attributes => [
        :show_in_dashboard,
        :start_date,
        :end_date,
        :frequency_type_id,
        :active
      ]
    ]
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
      activity.operational? and active
    else
      false
    end
  end

  def detect_changes?
    has_changes = false

    trigger_fields = [
        :start_date,
        :end_date
    ]

    trigger_fields.each do |field|
      if self.changes.include? field.to_s
        has_changes = true
        break
      end
    end

    has_changes
  end

  #-----------------------------------------------------------------------------
  # Protected Methods
  #-----------------------------------------------------------------------------
  protected

  # Set resonable defaults for a new asset event
  def set_defaults
    self.active = self.active.nil? ? true : self.active
  end

  #-----------------------------------------------------------------------------
  # Private Methods
  #-----------------------------------------------------------------------------
  private

end
