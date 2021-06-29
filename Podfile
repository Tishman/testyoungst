# Uncomment the next line to define a global platform for your project
require 'cocoapods-catalyst-support'

platform :ios, '14.1'
inhibit_all_warnings!

target 'YoungSt' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for YoungSt
  
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/DynamicLinks'
end

catalyst_configuration do
  verbose!

  ios 'Firebase/Analytics'
end

post_install do |installer|
  installer.configure_catalyst

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.1'
    end
  end
end
