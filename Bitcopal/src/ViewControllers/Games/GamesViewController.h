//
//  GamesViewController.h
//  Bitcopal
//
//  Created by Костюкевич Илья on 27.05.2018.
//  Copyright © 2018 Open Whisper Systems. All rights reserved.
//

#import <SignalMessaging/SignalMessaging.h>
#import "OWSTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class OWSNavigationController;

@interface GamesViewController : OWSTableViewController

+ (OWSNavigationController *)inModalNavigationController;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
