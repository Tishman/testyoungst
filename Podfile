# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'YoungSt' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'GoogleMLKit/Translate'

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["HEADER_SEARCH_PATHS"] ||= "$(inherited) "
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      config.build_settings['TVOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
