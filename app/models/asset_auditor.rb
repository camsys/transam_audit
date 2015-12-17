#-------------------------------------------------------------------------------
# AssetAuditor
#
# Generic auditor for auditing an asset inventory
#
#-------------------------------------------------------------------------------
class AssetAuditor < AbstractAuditor

  #-----------------------------------------------------------------------------
  # Takes set of properties and generates a list of assets that will be audited
  #-----------------------------------------------------------------------------
  def audit options={}

    # Loop through each org at a time
    Organization.all.each do |org|
      # Only process operational assets
      org.assets.operational.pluck(:object_key).each do |obj_key|
        asset = Asset.find_by(object_key: obj_key)
        check asset
      end
    end

  end
  #-----------------------------------------------------------------------------
  # Takes an asset (typed or untyped) and checks the compliance and updates the
  # audit table wth the results
  #-----------------------------------------------------------------------------
  def check a

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
    asset = a.is_typed? ? a : Asset.get_typed_asset a

    Rails.logger.debug "Testing asset #{asset.object_key} for compliance. Type is #{asset.class.name}"
    start_date = Chronic.parse('10/1/2015').to_date
    end_date = Chronic.parse('12/31/2015').to_date

    passed = true
    if asset.reported_condition_date.blank? or asset.reported_condition_date < start_date
      passed = false
      errors << "Condition has not been updated during the audit period"
    end

    if asset.service_status_date.blank? or asset.service_status_date < start_date
      passed = false
      errors << "Service Status has not been updated during the audit period"
    end

    if asset.respond_to? :milage_updates
      if asset.reported_mileage_date.blank? or asset.reported_mileage_date < start_date
        passed = false
        errors << "Mileage has not been updated during the audit period"
      end
    end

    audit = AuditResult.find_or_create_by(:organization_id => asset.organization_id, :auditable_id => asset.id, :auditable_type => 'Asset', :audit_id => @audit.id) do |aud|
      aud.audit_result_type_id = (passed == true) ? AuditResultType::AUDIT_RESULT_PASSED : AuditResultType::AUDIT_RESULT_FAILED
      if errors.present?
        aud.notes = errors.compact.join(' ')
      end
    end
    audit.save

  end

  #-----------------------------------------------------------------------------
  #-----------------------------------------------------------------------------
  def initialize(audit)
    super
  end

  #-----------------------------------------------------------------------------
  protected
  #-----------------------------------------------------------------------------

end
