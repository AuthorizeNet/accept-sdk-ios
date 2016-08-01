#
# Be sure to run `pod lib lint authorizenet-accept-ios' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

    s.name             = 'authorizenet-accept-ios'
    s.authors          = 'Authorize.Net'
    s.version          = '0.0.1'
    s.summary          = 'Authorize.Net Accept SDK for iOS'
    s.homepage         = 'https://visa.com'

    s.license          = { :type => 'VISA', :text => <<-LICENSE
                            © VISA Inc., 2016. All rights reserved.
                            LICENSE
                         }
    s.platform         = :ios, "8.4"

    s.source           = {:git => 'https://github.com/AuthorizeNet/accept-sdk-ios.git'}

    s.requires_arc = true

    s.vendored_frameworks = 'AcceptSDK\ Binary/AcceptSDK.framework'

end

