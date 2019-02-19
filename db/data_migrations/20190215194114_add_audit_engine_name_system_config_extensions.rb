class AddAuditEngineNameSystemConfigExtensions < ActiveRecord::DataMigration
  def up
    SystemConfigExtension.find_by({class_name: 'TransamAsset', extension_name: 'TransamAuditable', active: true}).update!(engine_name: 'audit')
  end
end