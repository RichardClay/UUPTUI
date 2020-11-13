#
# Be sure to run `pod lib lint UUPTUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UUPTUI'
  s.version          = '1.1.2'
  s.summary          = 'UU跑腿UI公共组件库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'UI组件'
  s.homepage         = 'http://uugit.uupt.com/zhangwenbin/UUPTUI.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lz' => '750460196@qq.com' }
  s.source           = { :git => 'http://uugit.uupt.com/zhangwenbin/UUPTUI.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '9.0'
  s.dependency 'Masonry'

  s.subspec 'UUPTUICoreKit' do |b|
     b.source_files = 'UUPTUI/Classes/UUPTUICoreKit/**/*'
  end
  s.subspec 'Component' do |a|
      a.dependency 'UUPTUI/UUPTUICoreKit'
      a.source_files = 'UUPTUI/Classes/Component/*.{h,m}'
  end
end
