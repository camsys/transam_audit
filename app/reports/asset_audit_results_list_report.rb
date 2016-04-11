class AssetAuditResultsListReport < Report
  def get_data(conditions)
    AuditResult.search_auditable(conditions, @auditable_type, {disposition_date: nil})
  end
end