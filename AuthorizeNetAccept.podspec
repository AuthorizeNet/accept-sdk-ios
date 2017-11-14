#
# Be sure to run `pod lib lint AuthorizeNetAccept.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

    s.name                  = 'AuthorizeNetAccept'
    s.authors               = 'Authorize.Net'
    s.version               = '0.2.1'
    s.summary               = 'Authorize.Net Accept SDK for iOS'
    s.homepage              = 'https://developer.authorize.net'

    s.license               = 'https://github.com/AuthorizeNet/accept-sdk-ios/blob/master/LICENSE.md'
    s.platform              = :ios, "8.4"

    s.source                = {:git => 'https://github.com/hatboysoftware/accept-sdk-ios.git', :tag => s.version.to_s}
    s.requires_arc = true

    s.module_name           = 'AuthorizeNetAccept'
    s.vendored_framework    = 'AcceptSDK-Framework/AcceptSDK.framework'
end

