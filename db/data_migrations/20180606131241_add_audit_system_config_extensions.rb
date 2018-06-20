class AddAuditSystemConfigExtensions < ActiveRecord::DataMigration
  def up
    system_config_extensions = [
        {class_name: 'TransamAsset', extension_name: 'TransamAuditable', active: true}
    ]

    system_config_extensions.each do |extension|
      SystemConfigExtension.create!(extension)
    end
  end
end