class AddFtaCategoryAssetToAuditResult < ActiveRecord::Migration[5.2]
  def change
    add_column :audit_results, :fta_asset_category_id, :integer
    add_foreign_key :audit_results, :fta_asset_categories, index: true
  end
end
