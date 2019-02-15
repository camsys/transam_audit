class AddAuditEngineNameSystemConfigExtensions < ActiveRecord::DataMigration
  def up
    SystemConfigExetnsion.find_by({class_name: 'TransamAsset', extension_name: 'TransamAuditable', active: true}).update!(engine_name: 'audit')
  end
end