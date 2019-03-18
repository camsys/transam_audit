class AddFilterableClassNameToAudits < ActiveRecord::Migration[5.2]
  def change
    add_column :audits, :filterable_class_name, :string
  end
end
