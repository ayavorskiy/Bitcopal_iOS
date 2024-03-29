//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWSDeviceProvisioningCodeService.h"
#import "OWSRequestFactory.h"
#import "TSNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const OWSDeviceProvisioningCodeServiceProvisioningCodeKey = @"verificationCode";

@interface OWSDeviceProvisioningCodeService ()

@property (readonly) TSNetworkManager *networkManager;

@end

@implementation OWSDeviceProvisioningCodeService

- (instancetype)initWithNetworkManager:(TSNetworkManager *)networkManager
{

    self = [super init];
    if (!self) {
        return self;
    }

    _networkManager = networkManager;

    return self;
}

- (instancetype)init
{
    return [self initWithNetworkManager:[TSNetworkManager sharedManager]];
}

- (void)requestProvisioningCodeWithSuccess:(void (^)(NSString *))successCallback
                                   failure:(void (^)(NSError *))failureCallback
{
    TSRequest *request = [OWSRequestFactory deviceProvisioningCodeRequest];
    [self.networkManager makeRequest:request
        success:^(NSURLSessionDataTask *task, id responseObject) {
            DDLogVerbose(@"ProvisioningCode request succeeded");
            if ([(NSObject *)responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = (NSDictionary *)responseObject;
                NSString *provisioningCode =
                    [responseDict objectForKey:OWSDeviceProvisioningCodeServiceProvisioningCodeKey];
                successCallback(provisioningCode);
            }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (!IsNSErrorNetworkFailure(error)) {
                OWSProdError([OWSAnalyticsEvents errorProvisioningCodeRequestFailed]);
            }
            DDLogVerbose(@"ProvisioningCode request failed with error: %@", error);
            failureCallback(error);
        }];
}

@end

NS_ASSUME_NONNULL_END
