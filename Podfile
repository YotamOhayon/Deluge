# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def production_pods
    pod 'Delugion', :path => '../Delugion'
    pod 'RxSwift', '~> 4.0'
    pod 'RxCocoa', '~> 4.0'
    pod 'RxOptional', '~> 3.3'
    pod 'Swinject', '~> 2.1'
    pod 'SwinjectStoryboard', '~> 1.1'
    pod 'Fabric', '~> 1.7'
    pod 'Crashlytics', '~> 3.9'
    pod 'Reveal-SDK', :configurations => ['Debug']
    pod 'BuddyBuildSDK', '~> 1.0'
    pod 'SwiftyBeaver', '~> 1.4'
    pod 'SwipeCellKit', '~> 2.0'
    pod 'RxDataSources', '~> 3.0'
    pod 'ReachabilitySwift', '~> 4.1'
end

def test_pods
    pod 'Quick', '~> 1.2'
    pod 'Nimble', '~> 7.0'
    pod 'RxNimble', '~> 4.1'
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest',     '~> 4.0'
    pod 'OHHTTPStubs/Swift', '~> 6.0'
end

target 'Deluge' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  
  # Pods for Deluge
  production_pods
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '4.0'
          end
      end
  end
  
  target 'DelugeTests' do
    inherit! :search_paths
    # Pods for testing
    test_pods
  end
end

target 'DelugePlayground' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    inhibit_all_warnings!
    
    # Pods for DelugePlayground
    production_pods
end
