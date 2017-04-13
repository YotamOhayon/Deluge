# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Deluge' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Delugion', :path => '../Delugion/'
  pod 'RxSwift', '~> 3.3'
  pod 'RxCocoa', '~> 3.3'
  pod 'RxOptional', '~> 3.1'
  pod 'Swinject', '~> 2.0'
  pod 'SwinjectStoryboard', '~> 1.0'
  pod 'KDCircularProgress', :path => '../KDCircularProgress/'

  # Pods for Deluge

  target 'DelugeTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick', '~> 1.1'
    pod 'Nimble', '~> 6.1'
  end

end
