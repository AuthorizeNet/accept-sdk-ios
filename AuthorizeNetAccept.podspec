#
# Be sure to run `pod lib lint AcceptSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

    s.name             = 'AuthorizeNetAccept'
    s.authors          = 'Authorize.Net'
    s.version          = '0.0.2'
    s.summary          = 'Authorize.Net Accept SDK for iOS'
    s.homepage         = 'https://developer.authorize.net'

    s.license          = 'https://github.com/AuthorizeNet/accept-sdk-ios/blob/master/LICENSE.md'
    s.platform         = :ios, "8.4"

    s.source           = {:git => 'https://github.com/AuthorizeNet/accept-sdk-ios.git'}

    s.requires_arc = true

    s.ios.vendored_frameworks = 'AcceptSDK\ Binary/AcceptSDK.framework'

end

