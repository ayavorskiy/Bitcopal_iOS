//
//  Created by Ilya Kostyukevich. All rights reserved.
//

@interface TSRequest : NSMutableURLRequest

@property (nonatomic) BOOL shouldHaveAuthorizationHeaders;

@property (nonatomic, readonly) NSDictionary *parameters;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithURL:(NSURL *)URL;

- (instancetype)initWithURL:(NSURL *)URL
                cachePolicy:(NSURLRequestCachePolicy)cachePolicy
            timeoutInterval:(NSTimeInterval)timeoutInterval NS_UNAVAILABLE;

- (instancetype)initWithURL:(NSURL *)URL
                     method:(NSString *)method
                 parameters:(nullable NSDictionary<NSString *, id> *)parameters;

+ (instancetype)requestWithUrl:(NSURL *)url
                        method:(NSString *)method
                    parameters:(nullable NSDictionary<NSString *, id> *)parameters;

@end
