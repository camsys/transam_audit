class RemoveFtaAssetCategoryIdFromAuditResults < ActiveRecord::Migration[5.2]
  def change
    remove_column :audit_results, :fta_asset_category_id, :int if column_exists?(:audit_results, :fta_asset_category_id)
  end
end
