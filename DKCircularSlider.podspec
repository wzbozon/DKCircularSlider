#
# Be sure to run `pod lib lint DKCircularSlider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DKCircularSlider'
  s.version          = '1.0.1'
  s.summary          = 'Slider that has a form of a circle'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Slider control in a form of circle written in Objective C. Optional limiter can be set. Can be disabled. Can be set to constant value.
                       DESC

  s.homepage         = 'https://github.com/wzbozon/DKCircularSlider'
  s.screenshots     = 'http://blog.alwawee.com/wp-content/uploads/2017/11/1.png', 'http://blog.alwawee.com/wp-content/uploads/2017/11/2.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dennis Kutlubaev' => 'kutlubaev.denis@gmail.com' }
  s.source           = { :git => 'https://github.com/wzbozon/DKCircularSlider.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DKCircularSlider/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DKCircularSlider' => ['DKCircularSlider/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
