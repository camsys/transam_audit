class CreateTransamAuditTables < ActiveRecord::Migration

  def self.up

    create_table :audit_result_types do |t|
      t.string  :name,        :limit => 32,   :null => false
      t.string  :description, :limit => 254,  :null => false
      t.boolean :active,                      :null => false
    end

    create_table :audit_results do |t|
      t.integer :audit_id,                        :null => false
      t.integer :organization_id,                 :null => false
      t.integer :audit_result_type_id,            :null => false
      t.integer :auditable_id,                    :null => false
      t.string  :auditable_type,  :limit => 64,   :null => false
      t.string  :class_name,      :limit => 64,   :null => false
      t.string  :notes,           :limit => 1024, :null => false
      t.timestamps
    end

    add_index     :audit_results, [:audit_id],              :name => :audit_results_idx1
    add_index     :audit_results, [:auditable_type, :auditable_id], :name => :audit_results_idx2
    add_index     :audit_results, [:class_name],            :name => :audit_results_idx3
    add_index     :audit_results, [:audit_result_type_id],  :name => :audit_results_idx4

    create_table :audits do |t|
      t.string    :object_key,          :limit => 12,   :null => false
      t.integer   :activity_id
      t.string    :name,                :limit => 32,   :null => false
      t.string    :description,         :limit => 254,  :null => false
      t.string    :instructions,        :limit => 254,  :null => false
      t.string    :schedule,            :limit => 64,   :null => false
      t.string    :auditor_class_name,  :limit => 64,   :null => false
      t.datetime  :last_run
      t.boolean   :active,                              :null => false
      t.timestamps
    end

    add_index     :audits, [:object_key], :name => :audits_idx1
    add_index     :audits, [:active],     :name => :audits_idx2

  end

  def self.down
    drop_table :audit_result_types
    drop_table :audits
    drop_table :audit_results
  end

end
