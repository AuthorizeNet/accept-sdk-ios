# Authorize.Net Accept Mobile SDK for iOS

This SDK allows mobile developers to provide credit card payment functionality within their iOS applications, without having to pass sensitive card data back to their application backend servers.  For more information on including payments in your mobile application see our [InApp Payments Guide](http://developer.authorize.net/api/reference/features/in-app.html)   
   
## SDK Installation 

### CocoaPods
```
    pod 'AuthorizeNetAccept'  
```  

### Manual Installation

Include the ```AcceptSDK.framework``` in the application. In Xcode, select the main project file for the target. In the "General" section of the project's properties, scroll down to "Embedded Binaries", press the plus sign (+), and select the framework.

Once included, make sure in “Build Settings” tab, in section “Search Paths”, the path to these frameworks are added correctly. 

## SDK Usage
### Initialize the SDK and set the data to be dispatched directly to Authorize.Net
```swift
        
        let handler = AcceptSDKHandler(environment: AcceptSDKEnvironment.ENV_TEST)
        
        let request = AcceptSDKRequest()
        request.merchantAuthentication.name = kClientName
        request.merchantAuthentication.clientKey = kClientKey
        
        request.securePaymentContainerRequest.webCheckOutDataType.token.cardNumber = self.cardNumberBuffer
        request.securePaymentContainerRequest.webCheckOutDataType.token.expirationMonth = self.cardExpirationMonth
        request.securePaymentContainerRequest.webCheckOutDataType.token.expirationYear = self.cardExpirationYear
        request.securePaymentContainerRequest.webCheckOutDataType.token.cardCode = self.cardVerificationCode
```
### Register the callback and call getTokenWithRequest
```swift
        handler!.getTokenWithRequest(request, successHandler: { (inResponse:AcceptSDKTokenResponse) -> () in
            dispatch_async(dispatch_get_main_queue(),{
                self.updateTokenButton(true)

                self.activityIndicatorAcceptSDKDemo.stopAnimating()
                print("Token--->%@", inResponse.getOpaqueData().getDataValue())
                var output = String(format: "Response: %@\nData Value: %@ \nDescription: %@", inResponse.getMessages().getResultCode(), inResponse.getOpaqueData().getDataValue(), inResponse.getOpaqueData().getDataDescriptor())
                output = output + String(format: "\nMessage Code: %@\nMessage Text: %@", inResponse.getMessages().getMessages()[0].getCode(), inResponse.getMessages().getMessages()[0].getText())
                self.textViewShowResults.text = output
                self.textViewShowResults.textColor = UIColor.greenColor()
            })
        }) { (inError:AcceptSDKErrorResponse) -> () in
            self.activityIndicatorAcceptSDKDemo.stopAnimating()
            self.updateTokenButton(true)

            let output = String(format: "Response:  %@\nError code: %@\nError text:   %@", inError.getMessages().getResultCode(), inError.getMessages().getMessages()[0].getCode(), inError.getMessages().getMessages()[0].getText())
            self.textViewShowResults.text = output
            self.textViewShowResults.textColor = UIColor.redColor()
            print(output)
        }

```
### Using the Accept Payment Token to Create a Transaction Request
Your server constructs a transaction request using the [Authorize.Net API](https://developer.authorize.net/api/reference/#payment-transactions-create-an-accept-payment-transaction), placing the encrypted payment information that it received in previous step in the opaqueData element.
```json
   {
    "createTransactionRequest": {
        "merchantAuthentication": {
            "name": "YOUR_API_LOGIN_ID",
            "transactionKey": "YOUR_TRANSACTION_KEY"
        },
        "refId": "123456",
        "transactionRequest": {
            "transactionType": "authCaptureTransaction",
            "amount": "5",
            "payment": {
                "opaqueData": {
                    "dataDescriptor": "COMMON.ACCEPT.INAPP.PAYMENT",
                    "dataValue": "PAYMENT_NONCE_GOES_HERE"
                }
            }
        }
    }
}
```
### Using from Objective-C
Calling the SDK from Objective-C should be simple and intuitive:  

```objective-c

    AcceptSDKHandler *handler = [[AcceptSDKHandler alloc] initWithEnvironment:AcceptSDKEnvironmentENV_TEST];
    AcceptSDKRequest *request = [[AcceptSDKRequest alloc] init];
    request.merchantAuthentication.name = @""; //name
    request.merchantAuthentication.clientKey = @""; //clientkey
   
    request.securePaymentContainerRequest.webCheckOutDataType.token.cardNumber = @""; //cardnumber
    request.securePaymentContainerRequest.webCheckOutDataType.token.expirationMonth = @"";
    request.securePaymentContainerRequest.webCheckOutDataType.token.expirationYear = @"";
    request.securePaymentContainerRequest.webCheckOutDataType.token.cardCode = @"";
   
    [handler getTokenWithRequest:request successHandler:^(AcceptSDKTokenResponse * _Nonnull token) {
        NSLog(@"success %@", token.getOpaqueData.getDataValue);
    } failureHandler:^(AcceptSDKErrorResponse * _Nonnull error) {
        NSLog(@"failed... );
    }];
```
## Sample Application
We have a sample application which demonstrates the SDK usage:  
   https://github.com/AuthorizeNet/accept-sample-ios
   
  
## Apple In-App Purchase API  
Please remember that you are required to use Apple’s In-App Purchase API to sell virtual goods such as premium content for your app, and subscriptions for digital content. Specifically, Apple’s developer terms require that the In-App Purchase API must be used for digital “content, functionality, or services” such as premium features or credits. See https://developer.apple.com/app-store/review/guidelines/ for more details.
