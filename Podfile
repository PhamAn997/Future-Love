# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
platform :ios, '15.0'
inhibit_all_warnings!
target 'FutureLove' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FutureLove
  pod 'SnapKit', '~> 5.6.0'
  pod 'Toast-Swift'
  pod 'DropDown'
  pod 'R.swift'
  pod 'SwiftLint', :inhibit_warnings => true
  pod 'DeviceKit', '~> 4.0'

  # Network
  pod 'AlamofireImage', '~> 4.1'
  pod 'SETabView'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
    if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
      target.build_configurations.each do |config|
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end
