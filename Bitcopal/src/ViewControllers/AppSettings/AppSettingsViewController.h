//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWSTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class OWSNavigationController;

@interface AppSettingsViewController : OWSTableViewController

@property (assign, nonatomic) BOOL isModal;

+ (OWSNavigationController *)inModalNavigationController;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END