#
# Be sure to run `pod lib lint AcceptSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

    s.name             = 'AcceptSDK'
    s.authors          = 'VISA Inc.'
    s.version          = '1.0.0'
    s.summary          = 'VISA iOS Accept SDK'
    s.homepage         = 'https://visa.com'

    s.license          = { :type => 'VISA', :text => <<-LICENSE
                            © VISA Inc., 2016. All rights reserved.
                            LICENSE
                         }
    s.platform         = :ios, "8.4"

    s.source           = {:git => 'https://github.com/RakeshVisa/accept-sdk-ios.git'}

    s.requires_arc = true

    s.default_subspec = 'Source'

    s.subspec 'Source' do |source|

        source.source_files  = "AcceptSDK/**/*.{swift}"
        source.xcconfig = { 'ENABLE_BITCODE' => 'NO' }

    end

end

