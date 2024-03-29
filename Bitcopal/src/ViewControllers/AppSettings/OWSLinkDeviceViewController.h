//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWSQRCodeScanningViewController.h"
#import <SignalMessaging/OWSViewController.h>

NS_ASSUME_NONNULL_BEGIN

@class OWSLinkedDevicesTableViewController;

@interface OWSLinkDeviceViewController : OWSViewController <OWSQRScannerDelegate>

@property OWSLinkedDevicesTableViewController *linkedDevicesTableViewController;

- (void)controller:(OWSQRCodeScanningViewController *)controller didDetectQRCodeWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
