# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'PhotoFeed' do

pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'GeoFire', :git => 'https://github.com/firebase/geofire-objc.git'
pod 'Toast-Swift', '~> 2.0.0'
pod 'UIImage-Resize', '~> 1.0'
pod 'MBProgressHUD', '~> 1.0.0'
pod 'SelfSizingWaterfallCollectionViewLayout'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'GeoFire' then
            target.build_configurations.each do |config|
                config.build_settings['FRAMEWORK_SEARCH_PATHS'] = "#{config.build_settings['FRAMEWORK_SEARCH_PATHS']} ${PODS_ROOT}/FirebaseDatabase/Frameworks/ $PODS_CONFIGURATION_BUILD_DIR/GoogleToolboxForMac"
                config.build_settings['OTHER_LDFLAGS'] = "#{config.build_settings['OTHER_LDFLAGS']} -framework FirebaseDatabase"
            end
        end
    end
end
