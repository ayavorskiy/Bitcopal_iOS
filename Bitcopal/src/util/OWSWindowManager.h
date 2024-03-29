//
//  Created by Ilya Kostyukevich. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

// This VC can become first responder
// when presented to ensure that the input accessory is updated.
@interface OWSWindowRootViewController : UIViewController

@end

#pragma mark -

extern const UIWindowLevel UIWindowLevel_Background;

@interface OWSWindowManager : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)sharedManager;

- (void)setupWithRootWindow:(UIWindow *)rootWindow screenBlockingWindow:(UIWindow *)screenBlockingWindow;

- (void)setIsScreenBlockActive:(BOOL)isScreenBlockActive;

#pragma mark - Calls

- (void)startCall:(UIViewController *)callViewController;
- (void)endCall:(UIViewController *)callViewController;
- (void)leaveCallView;
- (void)returnToCallView;
- (BOOL)hasCall;

@end

NS_ASSUME_NONNULL_END
