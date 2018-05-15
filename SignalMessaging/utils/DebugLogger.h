//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import <CocoaLumberjack/DDFileLogger.h>

NS_ASSUME_NONNULL_BEGIN

@interface DebugLogger : NSObject

+ (instancetype)sharedLogger;

- (void)enableFileLogging;

- (void)disableFileLogging;

- (void)enableTTYLogging;

- (void)wipeLogs;

- (NSArray<NSString *> *)allLogFilePaths;

@end

NS_ASSUME_NONNULL_END
