class AllowAuditResultClassNameToBeNil < ActiveRecord::Migration[5.2]
  def change
    change_column :audit_results, :class_name, :string, null: true
  end
end
