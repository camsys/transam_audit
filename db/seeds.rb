#encoding: utf-8

# determine if we are using postgres or mysql
is_mysql = (ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'mysql2')
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

merge_tables = %w{ }

merge_tables.each do |table_name|
  puts "  Merging #{table_name}"
  data = eval(table_name)
  klass = table_name.classify.constantize
  data.each do |row|
    x = klass.new(row)
    x.save!
  end
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
