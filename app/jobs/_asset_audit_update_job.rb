#------------------------------------------------------------------------------
#
# AssetAuditUpdateJob
#
# This job is usally created after an auditable asset has been updated and it
# simply runs each operational audit on the asset to update the audit results
#
#------------------------------------------------------------------------------
class AssetAuditUpdateJob < AbstractAssetUpdateJob

  def execute_job(asset)

    asset.audits.each do |audit|
      if audit.operatonal?
        audit.get_auditor.update_status asset
      end
    end
  end

  def prepare
    Rails.logger.debug "Executing AssetAuditUpdateJob at #{Time.now.to_s} for Asset #{object_key}"
  end

end
