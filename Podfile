# Uncomment this line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
#source 'https://github.com/hyacinthxinxin/TingSpectrumPodSpecs.git'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

platform :ios, '9.0'

target 'uSparrow' do
  use_frameworks!

pod 'Alamofire',
:git => 'https://github.com/Alamofire/Alamofire.git',
:branch => 'master'

pod 'SwiftyJSON',
:git => 'https://github.com/BaiduHiDeviOS/SwiftyJSON.git',
:branch => 'swift3'

pod 'PureLayout'
pod 'JDStatusBarNotification'
#pod "GCDWebServer", "~> 3.0"
#pod "GCDWebServer/WebUploader", "~> 3.0"
#pod "GCDWebServer/WebDAV", "~> 3.0"

end
