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
  swift_version = "3.0"

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
