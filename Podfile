# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'PNA-ObjectC' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

    pod 'Firebase/Messaging'
    pod 'SDWebImage'
    pod 'SQLCipher'
    pod 'SSZipArchive'
    pod 'TouchJSON'
    pod 'GDataXML-HTML'
    pod 'AESCrypt'
    pod 'GoogleTagManager', '3.15.1'
    pod 'GoogleSignIn'
    pod 'GoogleMaps'
    pod 'NSHash'
    pod 'GTMNSString-HTML', :git => 'https://github.com/siriusdely/GTMNSString-HTML.git'
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
    pod 'InstagramKit'
    pod 'XCDYouTubeKit'
    pod 'DGActivityIndicatorView'
    pod 'EGOTableViewPullRefreshAndLoadMore'
    pod 'SocketIO'
    pod 'DBCamera'
    pod 'SWRevealViewController'
  target 'PNA-ObjectCTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PNA-ObjectCUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'GTMNSString-HTML'
            target.build_configurations.each do |config|
                config.build_settings['OTHER_CFLAGS'] = '-fno-objc-arc -w -Xanalyzer -analyzer-disable-all-checks'
            end
        end
    end
end

