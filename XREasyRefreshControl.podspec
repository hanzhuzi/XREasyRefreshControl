#
#  Be sure to run `pod spec lint XREasyRefreshControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = 'XREasyRefreshControl'
  s.version      = '0.2'
  s.summary      = 'A simple and easy to use refresh control, you can customize your personality refresh according to the requirements.'

  s.homepage     = 'https://github.com/hanzhuzi/XREasyRefreshControl'

  s.license      = 'MIT'
  s.author       = { 'hanzhuzi' => '1754410821@qq.com' }
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/hanzhuzi/XREasyRefreshControl.git', :tag => s.version }
  s.source_files  = 'Source/*.swift'

end
