class AddAuditDateRange < ActiveRecord::Migration
  def change
    add_column    :audits, :start_date, :date, :null => false, :after => :schedule
    add_column    :audits, :end_date, :date, :null => false, :after => :start_date
  end
end
