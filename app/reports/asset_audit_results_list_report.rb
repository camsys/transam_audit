class AssetAuditResultsListReport < Report
  def get_data(conditions)

    if conditions[:audit_result_type_id] == AuditResultType::AUDIT_RESULT_UNKNOWN
      audit_results = []

      not_tested = Asset.operational.where(organization_id: conditions[:organization_id], asset_subtype_id: AssetType.find_by(name: conditions[:class_name]).asset_subtypes.ids).where.not(id: AuditResult.where(conditions.except(:audit_result_type_id)).pluck(:auditable_id))
      not_tested.each do |no_audit_obj|
        audit_results << AuditResult.new(auditable: no_audit_obj, organization_id: no_audit_obj.organization_id)
      end
    else
      audit_results = AuditResult.search_auditable(conditions, 'Asset', {disposition_date: nil})
    end

    return audit_results
  end
end