# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ChatTogether' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ChatTogether
  pod 'SnapKit', '~> 5.0.0'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  
  # Facebook Login
  pod 'FBSDKLoginKit'
  
  # Google Sign In
  pod 'GoogleSignIn', '~> 5.0'
  
  # automatically match the deployment target
  post_install do |pi|
      pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
      end
  end
end
