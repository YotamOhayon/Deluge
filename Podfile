# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Deluge' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  pod 'Delugion', :git => 'https://github.com/yotamoo/Delugion.git'
  pod 'RxSwift', '~> 3.4'
  pod 'RxCocoa', '~> 3.4'
  pod 'RxOptional', '~> 3.1'
  pod 'Swinject', '~> 2.1'
  pod 'SwinjectStoryboard', '~> 1.1'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'Reveal-SDK', :configurations => ['Debug']
  pod 'RxReachability', '~> 0.1'
  pod 'BuddyBuildSDK', '~> 1.0'
  pod 'SwiftyBeaver', '~> 1.2'
  pod 'SwipeCellKit', '~> 1.8'
  pod 'RxDataSources', '~> 1.0'

  # Pods for Deluge

  target 'DelugeTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick', '~> 1.1'
    pod 'Nimble', '~> 7.0'
    pod 'RxNimble', '~> 3.0'
  end

end
