#
#  Be sure to run `pod spec lint XREasyRefreshControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/

Pod::Spec.new do |s|
  s.name = 'XREasyRefreshControl'
  s.version = '0.4'
  s.license = 'MIT'
  s.summary = 'A simple and easy to use refresh control, you can customize your personality refresh'
  s.homepage = 'https://github.com/hanzhuzi/XREasyRefreshControl'
  s.authors = { 'hanzhuzi' => '1754410821@qq.com' }
  s.source = { :git => 'https://github.com/hanzhuzi/XREasyRefreshControl.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  # s.osx.deployment_target = '10.10'
  # s.tvos.deployment_target = '9.0'
  # s.watchos.deployment_target = '2.0'

  s.swift_version = '3.2'
  s.source_files = 'Source/*.swift'
end
