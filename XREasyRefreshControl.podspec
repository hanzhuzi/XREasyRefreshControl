#
#  Be sure to run `pod spec lint XREasyRefreshControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/

Pod::Spec.new do |s|
  s.name     	 = 'XREasyRefreshControl'
  s.version  	 = '1.2.0'
  s.license  	 = { :type => 'MIT', :file => 'LICENSE'}
  s.summary  	 = 'A powerful and lightweight pull-down refresh and pull-up load control.'
  s.homepage 	 = 'https://github.com/hanzhuzi/XREasyRefreshControl'
  s.author       = '是心作佛'
  s.authors      = { 'hanzhuzi' => '1754410821@qq.com' }
  s.source       = { :git => 'https://github.com/hanzhuzi/XREasyRefreshControl.git', :tag => s.version }
  s.requires_arc = true

  s.ios.deployment_target = '8.0'

  s.ios.framework  = 'UIKit', 'Foundation'
  s.module_name    = 'XREasyRefresh'
  s.swift_version  = '3.2'
  s.source_files   = 'Source/**/*.swift'
end
