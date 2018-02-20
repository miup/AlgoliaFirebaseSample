platform :ios, '11'
inhibit_all_warnings!

use_frameworks!

target 'AlgoliaFirebaseSample' do
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Firebase/Crash'
  pod 'Firebase/Messaging'
  pod 'Firebase/Performance'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'Alertift', '~> 3.0'
  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'
  pod 'RxOptional'
  pod 'DateToolsSwift'
  pod 'RxKeyboard'
  pod 'Haptica'
  pod 'Instantiate'
  pod 'InstantiateStandard'
  pod 'ImageStore'
  pod 'Salada'
  pod 'Pick'
  pod 'I'
  pod 'SwiftRegExp'
  pod 'Algent'
  pod 'Tsuchi'
end

post_install do |installer|
  swift3_pods = %w(SwiftRegExp)
  installer.pods_project.targets.each do |target|
    if swift3_pods.include?(target.name)
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.2'
      end
    end
  end
end

