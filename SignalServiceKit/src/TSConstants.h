//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#ifndef TextSecureKit_Constants_h
#define TextSecureKit_Constants_h

typedef NS_ENUM(NSInteger, TSWhisperMessageType) {
    TSUnknownMessageType            = 0,
    TSEncryptedWhisperMessageType   = 1,
    TSIgnoreOnIOSWhisperMessageType = 2, // on droid this is the prekey bundle message irrelevant for us
    TSPreKeyWhisperMessageType      = 3,
    TSUnencryptedWhisperMessageType = 4,
};

#pragma mark Server Address

#define textSecureHTTPTimeOut 10

//#ifndef DEBUG

// Production
//#define textSecureWebSocketAPI @"wss://textsecure-service.whispersystems.org/v1/websocket/"
//#define textSecureServerURL @"https://textsecure-service.whispersystems.org/"
//#define textSecureCDNServerURL @"https://cdn.signal.org"
#define textSecureWebSocketAPI @"ws://ec2-13-125-101-33.ap-northeast-2.compute.amazonaws.com:8080/v1/websocket/"
#define textSecureServerURL @"http://ec2-13-125-101-33.ap-northeast-2.compute.amazonaws.com:8080/"
#define textSecureCDNServerURL @"http://d1kopcq685v1uo.cloudfront.net"
// Use same reflector for service and CDN
//#define textSecureServiceReflectorHost @"textsecure-service-reflected.whispersystems.org"
//#define textSecureCDNReflectorHost @"textsecure-service-reflected.whispersystems.org"
#define textSecureServiceReflectorHost @"ec2-13-125-101-33.ap-northeast-2.compute.amazonaws.com:8080"
#define textSecureCDNReflectorHost @"ec2-13-125-101-33.ap-northeast-2.compute.amazonaws.com:8080"


//#else
//
//// Staging
//#define textSecureWebSocketAPI @"wss://textsecure-service-staging.whispersystems.org/v1/websocket/"
//#define textSecureServerURL @"https://textsecure-service-staging.whispersystems.org/"
//#define textSecureCDNServerURL @"https://cdn-staging.signal.org"
//#define textSecureServiceReflectorHost @"meek-signal-service-staging.appspot.com";
//#define textSecureCDNReflectorHost @"meek-signal-cdn-staging.appspot.com";
//
//#endif]

#define textSecureAccountsAPI @"v1/accounts"
#define textSecureAttributesAPI @"/attributes/"

#define textSecureMessagesAPI @"v1/messages/"
#define textSecureKeysAPI @"v2/keys"
#define textSecureSignedKeysAPI @"v2/keys/signed"
#define textSecureDirectoryAPI @"v1/directory"
#define textSecureAttachmentsAPI @"v1/attachments"
#define textSecureDeviceProvisioningCodeAPI @"v1/devices/provisioning/code"
#define textSecureDeviceProvisioningAPIFormat @"v1/provisioning/%@"
#define textSecureDevicesAPIFormat @"v1/devices/%@"
#define textSecureProfileAPIFormat @"v1/profile/%@"
#define textSecureSetProfileNameAPIFormat @"v1/profile/name/%@"
#define textSecureProfileAvatarFormAPI @"v1/profile/form/avatar"
#define textSecure2FAAPI @"/v1/accounts/pin"

//#define SignalApplicationGroup @"group.org.whispersystems.signal.group"
#define SignalApplicationGroup @"group.com.chinaordercenter.bitcopal.group"

#endif
