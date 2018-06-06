class AddAuditSystemConfigExtensions < ActiveRecord::DataMigration
  def up
    # currently add auditable mixin to old assets as well
    system_config_extensions = [
        {class_name: 'Equipment', extension_name: 'TransamAuditable', active: true},
        {class_name: 'Vehicle', extension_name: 'TransamAuditable', active: true},
        {class_name: 'Locomotive', extension_name: 'TransamAuditable', active: true},
        {class_name: 'RailCar', extension_name: 'TransamAuditable', active: true},
        {class_name: 'SupportVehicle', extension_name: 'TransamAuditable', active: true},
        {class_name: 'TransitFacility', extension_name: 'TransamAuditable', active: true},
        {class_name: 'SupportFacility', extension_name: 'TransamAuditable', active: true},

        {class_name: 'CapitalEquipment', extension_name: 'TransamAuditable', active: true},
        {class_name: 'FacilityComponent', extension_name: 'TransamAuditable', active: true},
        {class_name: 'ServiceVehicle', extension_name: 'TransamAuditable', active: true},
        {class_name: 'RevenueVehicle', extension_name: 'TransamAuditable', active: true},
        {class_name: 'Facility', extension_name: 'TransamAuditable', active: true},
    ]

    system_config_extensions.each do |extension|
      SystemConfigExetnsion.create!(extension)
    end
  end
end