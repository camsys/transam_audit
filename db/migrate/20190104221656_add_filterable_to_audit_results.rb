class AddFilterableToAuditResults < ActiveRecord::Migration[5.2]
  def change
    add_reference :audit_results, :filterable, polymorphic: true
  end
end
