module TransamSubAuditable
  #-----------------------------------------------------------------------------
  #
  # TransamSubAuditable
  #
  # If an association needs to trigger the audit, insert this mixin so parent auditable runs auditable callbacks
  #
  #-----------------------------------------------------------------------------
  extend ActiveSupport::Concern

  included do
    after_save :force_save_parent_asset
    after_destroy :force_save_parent_asset
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
  # Protected Methods
  #-----------------------------------------------------------------------------
  protected

  def force_save_parent_asset
    # find parent
    parent_class_name = SystemConfigExtension.find_by(extension_name: 'TransamAuditable').class_name

    parent = self.send(parent_class_name.underscore)
    parent.send(:check_for_audit_changes)
    parent.send(:update_audits)
  end

end
