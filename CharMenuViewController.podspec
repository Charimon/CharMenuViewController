Pod::Spec.new do |s| 
  s.name = 'CharMenuViewController'
  s.version = '0.0.2'
  s.platform = :ios
  s.ios.deployment_target = '7.0'
  s.prefix_header_file = 'CharMenuViewController/CharMenuViewController-Prefix.pch'
  s.source_files = 'CharMenuViewController/lib/*.{h,m,c}'
  s.requires_arc = true
end
