//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import <SignalMessaging/OWSViewController.h>

NS_ASSUME_NONNULL_BEGIN

@class HomeViewController;

@interface ProfileViewController : OWSViewController

- (instancetype)init NS_UNAVAILABLE;

+ (BOOL)shouldDisplayProfileViewOnLaunch;

+ (void)presentForAppSettings:(UINavigationController *)navigationController;
+ (void)presentForRegistration:(UINavigationController *)navigationController;
+ (void)presentForUpgradeOrNag:(HomeViewController *)presentingController NS_SWIFT_NAME(presentForUpgradeOrNag(from:));

@end

NS_ASSUME_NONNULL_END