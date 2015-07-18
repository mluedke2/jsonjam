Pod::Spec.new do |s|
  s.name             = "JSONJam"
  s.version          = "1.0.0"
  s.summary          = "JSON serialization and deserialization in Swift is my jam."
  s.homepage         = "https://github.com/mluedke2/JSONJam"
  s.license          = 'MIT'
  s.author           = { "mluedke2" => "mluedke2@gmail.com" }
  s.source           = { :git => "https://github.com/mluedke2/JSONJam.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/matt_luedke'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'JSONJam' => ['Pod/Assets/*.png']
  }

  s.dependency 'JSONHelper', '~> 1.6.0'
end
