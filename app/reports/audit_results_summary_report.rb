class AuditResultsSummaryReport < AbstractReport

  def initialize(attributes = {})
    super(attributes)
  end

  def get_data(audit, organization_id_list, type, audited_must_meet, audited_must_not_meet)
    labels = ["Org", "Type", 'Total', "Passed", "Failed"]
    data = []
    Rails.logger.debug "Org Ids = #{organization_id_list}"

    # Process each org in turn
    org_data = Organization.where(id: organization_id_list).pluck(:id, :short_name).to_h
    organization_id_list.each do |org_id|
      org_short_name = org_data[org_id]
      Rails.logger.debug "Summarizing for #{org_short_name}"

      # Summarize this org/audit combination by class name. This return an array
      # of class names and counts
      audit_results_criteria = {:audit_id => audit.id, :organization_id => org_id, :auditable_type => type}
      results = AuditResult.search_auditable(audit_results_criteria, type, audited_must_meet, audited_must_not_meet)
      summary = results.group(:class_name).count
      failed_summary = results.where(:audit_result_type => AuditResultType::AUDIT_RESULT_FAILED).group(:class_name).count
      summary.each do |class_name, count|
        if count > 0
          total   = count
          failed  = failed_summary[class_name].to_i
          data << [org_short_name, class_name, total, (total - failed), failed]
        end
      end
    end

    return [labels, data]
  end

end
