#
# Be sure to run `pod lib lint SectorMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SectorMenu'
  s.version          = '1.0.0'
  s.summary          = 'Sector Menu（扇形菜单）是一种‌环形布局的交互控件‌，通过动态展开子菜单项形成扇形或圆弧形界面。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
   1.‌环形动态布局‌
   2.流畅的交互动画
   3.触控精准响应‌
                       DESC

  s.homepage         = 'https://github.com/Clemmie-L/SectorMenu'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Clemmie' => '379644692@qq.com' }
  s.source           = { :git => 'https://github.com/Clemmie-L/SectorMenu.git', :tag => "#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.swift_version = '5.0'
  
  s.ios.deployment_target = '15.0'

  s.source_files = 'SectorMenu/Classes/*.swift'
  
  # s.resource_bundles = {
  #   'SectorMenu' => ['SectorMenu/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'SnapKit'
end
