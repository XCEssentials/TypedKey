Pod::Spec.new do |s|

  s.name                      = 'MKHTypedKey'
  s.version                   = '1.0.0'
  s.summary                   = 'Generic key for explicit type safe access to values from any key-value storage.'
  s.homepage                  = 'https://github.com/maximkhatskevich/#{s.name}'
  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }
  s.ios.deployment_target     = '8.0'
  s.source                    = { :git => '#{s.homepage}.git', :tag => '#{s.version}' }
  s.ios.source_files          = 'Src/*.swift'
  s.requires_arc              = true
  s.social_media_url          = 'http://www.linkedin.com/in/maximkhatskevich'

end
