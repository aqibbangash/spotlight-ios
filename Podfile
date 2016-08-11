use_frameworks!
pod 'Alamofire', '~> 3.3'
pod 'KFSwiftImageLoader', '~> 2.0'
pod 'QuickBlox'
pod 'Quickblox-WebRTC'
pod 'SVProgressHUD', '~> 2.0'
pod 'VideoBackgroundViewController', '~> 0.0'
pod 'GTToast', '~> 0.1'
pod 'MICountryPicker', '~> 0.1'
pod 'Google-Mobile-Ads-SDK', '~> 7.0'
pod 'Parse', '~> 1.13'
pod 'UIViewBadge', '~> 1.0'
pod 'VideoBackgroundViewController', '~> 0.0'
pod 'Fabric'
pod 'Crashlytics'
pod 'M13ProgressSuite', '~> 1.2'
pod 'iShowcase', '~> 1.5'
pod 'CTShowcase', '~> 1.0'
pod 'MBRateApp', '~> 0.1'
pod 'Firebase'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
