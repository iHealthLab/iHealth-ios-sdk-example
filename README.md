## iHealth-ios-sdk-example



#  Documentation for iOS Native SDK

This document describes how to use the iHealth Native SDK to accomplish the major operation: Connect
Device, Online Measurement, Offline Measurement and iHealth Device Management. 

## Authentication
If you want to use the iHealth Device, you must first call authentication method, can call after certification by iHealth relevant methods of the device. Get your app approved and download license file at: https://dev.ihealthlabs.com

Authentication API:
 -(void)commandSDKUserValidationWithLicense:(NSData
*)licenseData UserDeviceAccess:(DisposeSDKUserDeviceAccess)userDeviceAccess UserValidationSuccess:(DisposeSDKUserValidationSuccess)user ValidationSuccess DisposeErrorBlock:(DisposeSDKUserValidationErrorBlock)disposeValidationErrorBlock

## Native SDK supported devices list

### BP:
iHealth BP3 、iHealth BP3L、 iHealth BP5 、iHealth BP7 、iHealth BP7S、 iHealth Continua BP、 iHealth KN550BT、iHealth ABI 、iHealth ABP100、 iHealth BPM1、 iHealth BP5S 、iHealth KD723 
### HS:
iHealth HS2、iHealth HS2S、 iHealth HS3、 iHealth HS4、iHealth HS4S(Same with HS4)、 iHealth HS5、 iHealth HS5S、 iHealth HS6 、iHealth HS2SPro
### AM:
iHealth AM3 、iHealth AM3S 、iHealth AM4 、iHealth AM5
### BG:
iHealth BG1、iHealth BG1S、 iHealth BG3 、iHealth BG5、iHealth BG5S、iHealth BG1A
### PO:
iHealth PO3、iHealth PO3M、iHealth PO1
### Thermometer:
THV3 、TS28B 、NT13B、PT3SBT


### Authentication:
IHSDKCloudUser.h
### Library:
iHealthSDK2.12.0.a

1、supports iOS 12.0 and above. 

2、Frameworks

3、Configuration

Add 2 new Item in‘Supported external accessory protocols’,Different products need to add different
protocols.
If you use these devices, please contact us before submitting the Apple Store. We will generate a ppid based on the information you provided to help your app pass the review. If you do not have ppid, you may be rejected during the review.

If you're using BG5, you need to add
protocol:com.jiuan.BGV31

If you're using BP3, you need to add
protocol:com.jiuan.P930

If you're using BP5 or BP7, you need to add
protocol:com.jiuan.BPV20、com.jiuan.BPV23

If you're using ABI, you need to add
protocol:com.jiuan.BPV21

If you're using HS3, you need to add
protocol:com.ihealth.sc221

4、Other Settings

Scan and Connect

Before scanning and connecting the device, you need to call the authentication interface to get permission. 

After the authentication is passed, you can scan the connection. 

Otherwise, you will not be able to scan the connection to any device.

For classic bluetooth and audio devices, you don't need to call the scan connection method, just listen for the corresponding notification message to connect to the device. 

For classic bluetooth devices, you need the bluetooth option in the mobile Settings to manually connect the device. 

These devices include: iHealth BP3 、iHealth ABI、iHealth BP5 、iHealth BP7 、iHealth HS3、BG5. 

For the BG1, all you need to do is plug the device into the phone's headphone jack. 

Before scanning the device connection, you need to initialize the code of the corresponding device and add listening notification messages.
