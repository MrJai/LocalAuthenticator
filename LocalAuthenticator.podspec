#
# Be sure to run `pod lib lint LocalAuthenticator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LocalAuthenticator'
  s.version          = '0.1.0'
  s.summary          = 'Simple swift class to provide all the functionality to implement LocalAuthentication.'
  s.swift_versions = '4.2'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
"LocalAuthenticator provides you all the required methods to easily implement LocalAuthentication Framework, using some convenience methods to check if Face/Touch ID is available, and configured. You can also store your credentials in Userdefaults."
                       DESC

  s.homepage         = 'https://github.com/MrJai/LocalAuthenticator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MrJai' => 'junaid.rehmat.rana@gmail.com' }
  s.source           = { :git => 'https://github.com/MrJai/LocalAuthenticator.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/rana_jai'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LocalAuthenticator/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LocalAuthenticator' => ['LocalAuthenticator/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation', 'LocalAuthentication'
  # s.dependency 'AFNetworking', '~> 2.3'
end
