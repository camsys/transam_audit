class AddSubAuditableExtensionAssetEvents < ActiveRecord::DataMigration
  def up
    system_config_extensions = [{engine_name: 'audit', class_name: 'ConditionUpdateEvent', extension_name: 'TransamSubAuditable', active: true},
        {engine_name: 'audit', class_name: 'ServiceStatusUpdateEvent', extension_name: 'TransamSubAuditable', active: true}
    ]

    if SystemConfig.transam_module_loaded? :transit
      system_config_extensions << {engine_name: 'audit', class_name: 'MileageUpdateEvent', extension_name: 'TransamSubAuditable', active: true}
    end

    system_config_extensions.each do |ext|
      SystemConfigExtension.create!(ext)
    end
  end
end