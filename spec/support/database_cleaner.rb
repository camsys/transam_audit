RSpec.configure do |config|

  DatabaseCleaner.strategy = :truncation, {:only => %w[activities activity_logs assets asset_subtypes asset_types audits audit_results policies policy_asset_type_rules policy_asset_subtype_rules organizations organization_types users users_organizations users_roles]}
  config.before(:suite) do
    begin
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end
end
