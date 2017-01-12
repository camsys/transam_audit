class AssetAuditResultsListReport < Report
  def get_data(conditions)
    AuditResult.search_auditable(conditions, 'Asset', {disposition_date: nil})
  end
end