source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "8.0"
inhibit_all_warnings!

target 'RxSwiftDemos' do

    pod 'RxSwift', '~> 5'
    pod 'RxCocoa', '~> 5'
    pod 'RxDataSources', '~> 4.0'
    pod 'SnapKit'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'RxSwift'
            target.build_configurations.each do |config|
                if config.name == 'Debug'
                    config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                end
            end
        end
    end
end

