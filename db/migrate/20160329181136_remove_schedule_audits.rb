class RemoveScheduleAudits < ActiveRecord::Migration
  def change
    remove_column    :audits, :schedule
  end
end
