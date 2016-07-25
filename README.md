# Authorize.Net Accept Mobile SDK for iOS
   
   ****THIS IS A PRE-RELEASE SDK - NOT CURRENTLY AVAILABLE FOR PRODUCTION USAGE****
   
##SDK Installation 

### CocoaPods
````
     pod 'AuthorizeNetAccept'  
````  

### Manual Installation

Include the ```AcceptSDK.framework``` in to the application. Select Target, In Embedded Binaries, press the plus (+)
and select the framework.

Once included, make sure in “Build Settings” tab, in section “Search Paths” the path to these frameworks are added correctly. 

##SDK Usage 
````swift
TBD
````

##Sample Application
We have a sample application which demonstrates the SDK usage:  
   https://github.com/AuthorizeNet/accept-sample-ios
   
  
##Apple In-App Purchase API  
Please remember that you are required to use Apple’s In-App Purchase API to sell virtual goods such as premium content for your app, and subscriptions for digital content. Specifically, Apple’s developer terms require that the In-App Purchase API must be used for digital “content, functionality, or services” such as premium features or credits. See https://developer.apple.com/app-store/review/guidelines/ for more details.
