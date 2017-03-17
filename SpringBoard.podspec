#
# Be sure to run `pod lib lint SpringBoard.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SpringBoard'
  s.version          = '0.2.1'
  s.summary          = 'Follow iOS Desktop SpringBoard'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SpringBoard Project is aim to implement iOS Desktop SpringBoard.
                       DESC

  s.homepage         = 'https://github.com/WishesBest1986/SpringBoard.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LiJun' => 'lijun_211@126.com' }
  s.source           = { :git => 'https://github.com/WishesBest1986/SpringBoard.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SpringBoard/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SpringBoard' => ['SpringBoard/Assets/*.png']
  # }
  s.resource_bundles = {
    'SpringBoard' => ['SpringBoard/Assets/**/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Masonry', '~> 1.0.2'

end
