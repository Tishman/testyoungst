# Uncomment the next line to define a global platform for your project
require 'cocoapods-catalyst-support'

platform :ios, '14.1'

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
end
