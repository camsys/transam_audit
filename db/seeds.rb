#encoding: utf-8

# determine if we are using postgres or mysql
is_mysql = (ActiveRecord::Base.configurations[Rails.env]['adapter'].include?'mysql2')
is_sqlite =  (ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'sqlite3')

#------------------------------------------------------------------------------
#
# Lookup Tables
#
# These are the lookup tables for TransAM Audit
#
#------------------------------------------------------------------------------

puts "======= Processing TransAM Audit Lookup Tables  ======="

audit_result_types = [
  {:name => 'Passed', :description => 'All tests passed the audit', :active => true},
  {:name => 'Failed', :description => 'One or more tests failed the audit', :active => true},
  {:name => 'Untested', :description => 'One or more audit tests were not completed', :active => true}
]

activities = [
    {:name => 'Annual Inventory Asset Update', :description => 'All assets need to have the <strong>Service Status</strong>, <strong>Condition</strong>, and <strong>Mileage</strong> properties updated each quarter. Contact your BPT Technical manager for more information.', :job_name => 'AuditRunnerJob', :frequency_quantity => 1, :frequency_type_id => 4, :execution_time => 'Monday 00:01', :show_in_dashboard => true, :active => true, :start_date => Date.new(2015,10,1), :end_date => Date.new(2016,2,29)}
]

audits = [
    {:belongs_to => 'activity', :activity => 'Annual Inventory Asset Update', :name => 'Annual Inventory Update', :auditor_class_name => 'AssetAuditor', :active => true, :description => 'Checks to see that each asset has had the <strong>Service Status</strong>, <strong>Condition</strong>, and <strong>Mileage</strong> (where appropriate) updated each quarter.', :instructions => 'Update the Service Status, Condition, and Mileage (where appropriate) values for each of the operational assets in your inventory each quarter.', :start_date => Date.new(2016,1,1), :end_date => Date.new(2016,3,31)}
]

# currently add auditable mixin to old assets as well
system_config_extensions = [
    {class_name: 'TransamAsset', extension_name: 'TransamAuditable', active: true}
]

lookup_tables = %w{ audit_result_types }

lookup_tables.each do |table_name|
  puts "  Loading #{table_name}"
  if is_mysql
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name};")
  elsif is_sqlite
    ActiveRecord::Base.connection.execute("DELETE FROM #{table_name};")
  else
    ActiveRecord::Base.connection.execute("TRUNCATE #{table_name} RESTART IDENTITY;")
  end
  data = eval(table_name)
  klass = table_name.classify.constantize
  data.each do |row|
    x = klass.new(row)
    x.save!
  end
end

#------------------------------------------------------------------------------
#
# Merge Tables
#
# These are merged tables TransAM Audit
#
#------------------------------------------------------------------------------

puts "======= Processing TransAM Audit Merge Tables  ======="

merge_tables = %w{ activities system_config_extensions }

merge_tables.each do |table_name|
  puts "  Merging #{table_name}"
  data = eval(table_name)
  klass = table_name.classify.constantize
  data.each do |row|
    x = klass.new(row.except(:belongs_to, :type))
    x.save!
  end
end

table_name = 'audits'
puts "  Loading #{table_name}"
if is_mysql
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name};")
elsif is_sqlite
  ActiveRecord::Base.connection.execute("DELETE FROM #{table_name};")
else
  ActiveRecord::Base.connection.execute("TRUNCATE #{table_name} RESTART IDENTITY;")
end
data = eval(table_name)
data.each do |row|
  x = Audit.new(row.except(:belongs_to, :activity))
  x.activity = Activity.find_by(:name => row[:activity])
  x.save!
end

puts "======= Processing TransAM Audit Reports  ======="

reports = [
]

table_name = 'reports'
puts "  Merging #{table_name}"
data = eval(table_name)
data.each do |row|
  puts "Creating Report #{row[:name]}"
  x = Report.new(row.except(:belongs_to, :type))
  x.report_type = ReportType.find_by(:name => row[:type])
  x.save!
end
