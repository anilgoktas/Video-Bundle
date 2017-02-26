# platform :ios, '9.0'

def corePods
  pod 'AsyncSwift'
  pod 'SwiftyTimer'
end

def uiPods
  pod 'PermissionScope'
end

target 'funimate' do
  use_frameworks!

  # Pods for funimate
  corePods
  uiPods

  target 'funimateTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'funimateUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
