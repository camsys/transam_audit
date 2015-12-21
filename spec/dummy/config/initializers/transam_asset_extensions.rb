# Add asset plugins for this app
Rails.configuration.to_prepare do
  Asset.class_eval do
    # Audits
    include TransamAuditable
  end
end
