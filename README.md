
# Two-Factor Authentication for smart Contracts

Following the hackathon's recommendation [44 hackathon ideas](https://blog.chain.link/44-ways-to-enhance-your-smart-contract-with-chainlink/) we decided to apply in **"Account Security"** section.

There are some Smart Contracts that due to its importance requires a second layer of security.   
In that cases this MVP provides a second factor of authentication using one of the wide spreaded apps such as Google Authenticator, Auth0, Microsoft Authenticator or Authy.

The service provider generates once a *secret code* , that is pre-shared with The company API and stored in the third party security app such as **Google Authenticator**. 

Every time The User triggers a special event that requires extra validation, the user sends a one time password (PIN) generated in the app based on the Secret code. This PIN is valid only for a small period of time and the most important is that the Secret code never travels through the smart contract. 

In order to test this MVP we have written a minimal python Company API that has the Users secret codes hardcoded in a Dictionary and is capable of validating the PINs.

In a further implementation this MVP could be enhanced using the SHA256 hashes of the PINs and creating an external adapter to compare them.  
          
[![Demo Two-Factor Authentication for smart Contracts](https://img.youtube.com/vi/6Yh3rmcrKRc/0.jpg)](https://www.youtube.com/watch?v=6Yh3rmcrKRc "Demo Two-Factor Authentication for smart Contracts")

![Twitter](/docs/img/twitter-logo.png)
[/DigitalBridgeIO](https://twitter.com/DigitalBridgeIO)

## How to try the demo

### 1) Set up the External APP in a smart phone

You have to Install an Authenticator App , for this example we used : Google Authenticator  that which documentation could be seen in : (https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en)

Then set up an account for the User ID entering her key that is pre shared with the api-poc.  
to perform the test we created 3 hardcoded user IDs with the keys. You can use any of them: 

* 'alice': 'VPPRAX5ZS3EAT3ID'
* 'bob'  : 'O73Y5FPODOZXHJ4G'
* 'joe'  : '6VG5WWIDWHLR3SYE'


![Google Authenticator](/docs/img/load-qr-sc-screenshot.jpeg)

### 2) Set up the smart contract

To test the demo You can follow 
https://docs.chain.link/docs/example-walkthrough#config

To create the Smart contract you can copy it from: 

https://github.com/apronotti/2fa-for-smartcontracts/blob/master/contract/GoogleAuthenticatorPINCheck.sol

### 3) Performing a test 

To test you can invoke the method via remix interface with the ID and the temporary PIN as Parameters. 

![Google Authenticator](/docs/img/ga-pin-gen-screenshot.jpeg)

requestGAPINCheck(ID,PIN)

ie: requestGAPINCheck("alice","464614")

The boolean variable currentPermission is true when the second factor success. 




