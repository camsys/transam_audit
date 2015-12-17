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

end
