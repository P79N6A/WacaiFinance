def post_install_hook(installer)
    require File.expand_path('ProjectConfigurator.rb', installer.sandbox.root.to_s + '/Neutron/iOS/Neutron/Neutron/Configurator/')
    ProjectConfigurator::configure_project(installer)
    
    require File.expand_path('TrinityConfigurator.rb', installer.sandbox.root.to_s + '/TrinityConfiguration/iOS/TrinityConfiguration/TrinityConfiguration/')
    TrinityConfigurator.configure_project(installer)
    require File.expand_path('TrinityParams.rb', installer.sandbox.root.to_s + '/TrinityConfiguration/iOS/TrinityConfiguration/TrinityConfiguration/')
    TrinityParams.create_mods(installer)
    
    installer.aggregate_targets.each do |target|
        copy_pods_resources_path = "Pods/Target Support Files/#{target.name}/#{target.name}-resources.sh"
        string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
        assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
        text = File.read(copy_pods_resources_path)
        new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
        File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
    end

    require installer.sandbox.root.to_s + '/WaxDimensionPlugin/Classes/WaxDimensionConfigurator'
    configure_for_wax_dimension(installer)
end
