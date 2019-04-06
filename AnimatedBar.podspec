#
# Be sure to run `pod lib lint AnimatedBar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AnimatedBar'
  s.version          = '0.1.0'
  s.summary          = 'An animated bar with gradient colors'

  s.description      = <<-DESC
  The bar with animated filling and gradient.
  You can set a percentage of the filling, animation time and as a result see the animated filling.
                       DESC

  s.homepage         = 'https://github.com/AlexSmet/AnimatedBar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alex Smetannikov' => 'alexsmetdev@gmail.com' }
  s.source           = { :git => 'https://github.com/AlexSmet/AnimatedBar.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alexsmetdev'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AnimatedBar/Classes/*.{swift}'
end
