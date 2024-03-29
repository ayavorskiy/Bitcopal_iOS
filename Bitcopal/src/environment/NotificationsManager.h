//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWSCallNotificationsAdaptee.h"
#import <SignalServiceKit/NotificationsProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@class OWSContactsManager;
@class OWSPreferences;
@class SignalCall;
@class TSCall;
@class TSContactThread;

@interface NotificationsManager : NSObject <NotificationsProtocol, OWSCallNotificationsAdaptee>

- (void)clearAllNotifications;

#ifdef DEBUG

+ (void)presentDebugNotification;

#endif

@end

NS_ASSUME_NONNULL_END
