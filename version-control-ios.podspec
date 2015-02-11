Pod::Spec.new do |s|
  s.name             = "version-control-ios"
  s.version          = "0.1.0"
  s.summary          = "A cocoapod library to enable version-control on your iOS app"
  s.homepage         = "https://github.com/thegameofcode/version-control-ios"
  s.license          = 'MIT'
  s.author           = { "Luis Mesas" => "luismesas@gmail.com" }
  s.source           = { :git => "https://github.com/thegameofcode/version-control-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'version-control-ios' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
