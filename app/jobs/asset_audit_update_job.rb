#------------------------------------------------------------------------------
#
# AssetAuditUpdateJob
#
# This job is usally created after an auditable asset has been updated and it
# simply runs each operational audit on the asset to update the audit results
#
#------------------------------------------------------------------------------
class AssetAuditUpdateJob < AbstractAssetUpdateJob

  attr_accessor :audit

  def execute_job(asset)

    asset.audits.each do |audit|
      if audit.operatonal?
        audit.get_auditor.update_status asset
      end
    end
  end

  def check
    super
    raise ArgumentError, "audit can't be blank " if audit.blank?
  end

  def prepare
    Rails.logger.debug "Executing AssetAuditUpdateJob at #{Time.now.to_s} for Audit #{audit} and Asset #{object_key}"
  end

  def initialize(audit, object_key)
    super(object_key)
    self.object_key = object_key
  end

end
