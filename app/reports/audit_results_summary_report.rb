class AuditResultsSummaryReport < AbstractReport

  def initialize(attributes = {})
    super(attributes)
  end

  def get_data(audit, organization_id_list)
    labels = ["Org", "Type", 'Total', "Passed", "Failed"]
    data = []
    Rails.logger.debug "Org Ids = #{organization_id_list}"

    # Process each org in turn
    organization_id_list.each do |org_id|

      org = Organization.find(org_id)
      Rails.logger.debug "Summarizing for #{org.short_name}"

      # Summarize this org/audit combination by class name. This return an array
      # of class names and counts
      summary = AuditResult.where(:audit => audit, :organization => org).group(:class_name).count
      summary.each do |class_name, count|
        if count > 0
          total   = AuditResult.where(:audit => audit, :organization => org, :class_name => class_name).count
          failed  = AuditResult.where(:audit => audit, :organization => org, :class_name => class_name, :audit_result_type => AuditResultType::AUDIT_RESULT_FAILED).count
          data << [org.short_name, class_name, total, (total - failed), failed]
        end
      end
    end
    return [labels, data]
  end

end
