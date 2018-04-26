#
# Be sure to run `pod lib lint HuayingStatefulViewMachine.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HuayingStatefulViewMachine'
  s.version          = '0.1.0'
  s.summary          = 'A short description of HuayingStatefulViewMachine.'

  s.description      = <<-DESC
        HuayingStatefulViewMachine
                       DESC

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lzc1104' => '527004184@QQ.COM' }
  s.source           = { :git => 'https://github.com/Gaea-iOS/HuayingLoadingStatefulKit', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'HuayingStatefulViewMachine/Classes/**/*'
  s.resource_bundles = {
    'HuayingStatefulViewMachine' => ['HuayingStatefulViewMachine/Assets/*.png']
  }

end
