#-------------------------------------------------------------------------------
# AssetAuditor
#
# Generic auditor for auditing an asset inventory
#
#-------------------------------------------------------------------------------
class AssetAuditor < AbstractAuditor

  #-----------------------------------------------------------------------------
  # Only run audit if asset has changes related to audit
  #-----------------------------------------------------------------------------
  def detect_changes? asset
    has_changes = false

    asset_fields_audited = [
        :reported_condition_date,
        :reported_condition_type_id,
        :reported_condition_rating,
        :service_status_date,
        :service_status_type_id,
        :reported_mileage,
        :reported_mileage_date
    ]

    asset_fields_audited.each do |field|
      if asset.changes.include? field.to_s
        has_changes = true
        break
      end
    end

    has_changes
  end

  #-----------------------------------------------------------------------------
  # Takes set of properties and generates a list of assets that will be audited
  #-----------------------------------------------------------------------------
  def audit options={}

    # Loop through each org at a time
    Organization.all.each do |org|
      # Only process operational assets
      write_to_activity_log org, "Performing #{context.name} on asset inventory"
      Asset.operational.where('in_service_date <= ?', context.end_date).where(:organization => org).order(:asset_subtype_id).pluck(:object_key).each do |obj_key|
        asset = Asset.find_by(object_key: obj_key)
        update_status asset, context.start_date, context.end_date
      end
    end

  end
  #-----------------------------------------------------------------------------
  # Takes an asset (typed or untyped) and checks the compliance and updates the
  # audit table wth the results
  #-----------------------------------------------------------------------------
  def update_status a, start_date, end_date

    errors = []
    if a.nil?
      Rails.logger.debug "Asset cannot be nil"
      return errors
    end

    # Dont check disposed of assets
    if a.disposed?
      return errors
    end

    # Strongly type the asset but only if we need to
    asset = a.is_typed? ? a : Asset.get_typed_asset(a)

    Rails.logger.debug "Testing asset #{asset.object_key} for compliance between #{start_date} and #{end_date}. Type is #{asset.class.name}"

    passed = true
    if asset.service_status_type.try(:name) != "Out of Service" || (asset.service_status_date.present? && start_date <= asset.service_status_date && asset.service_status_date <= end_date)
      if asset.condition_updates.where(:event_date => start_date..end_date).count == 0
        passed = false
        errors << "Condition has not been updated during the audit period"
      end

      if asset.service_status_updates.where(:event_date => start_date..end_date).count == 0
        passed = false
        errors << "Service Status has not been updated during the audit period"
      end

      if asset.respond_to? :mileage_updates
        if asset.mileage_updates.where(:event_date => start_date..end_date).count == 0
          passed = false
          errors << "Mileage has not been updated during the audit period"
        end
      end
    end

    # If this audit result doesn't exist create it then update it otherwise
    # find the existing one and update it
    audit_result = AuditResult.find_or_initialize_by(:organization_id => asset.organization_id, :auditable_id => asset.id, :auditable_type => 'Asset', :audit_id => context.id, :class_name => asset.asset_type.name)
    audit_result.audit_result_type_id = (passed == true) ? AuditResultType::AUDIT_RESULT_PASSED : AuditResultType::AUDIT_RESULT_FAILED
    if errors.present?
      audit_result.notes = errors.join("\n")
    else
      audit_result.notes = ""
    end
    # save this update
    if audit_result.changed?
      audit_result.save
    else
      # just update updated_at to show asset was audited again and results are still the same
      audit_result.touch
    end

  end

  #-----------------------------------------------------------------------------
  #
  #-----------------------------------------------------------------------------
  def initialize(audit)
    super
  end

  #-----------------------------------------------------------------------------
  protected
  #-----------------------------------------------------------------------------

end
