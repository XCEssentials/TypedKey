Pod::Spec.new do |s|

  s.name                      = 'XCETypedKey'
  s.summary                   = 'Generic key for type safe access to values in any key-value storage.'
  s.version                   = '0.1.0'
  s.homepage                  = 'https://XCEssentials.github.io/TypedKey'

  s.source                    = { :git => 'https://github.com/XCEssentials/TypedKey.git', :tag => s.version }

  s.requires_arc              = true

  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }

  s.ios.deployment_target     = '8.0'

  s.source_files              = 'Sources/TypedKey/**/*.swift'

end