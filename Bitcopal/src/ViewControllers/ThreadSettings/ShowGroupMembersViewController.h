//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWSTableViewController.h"

@class TSGroupThread;

@interface ShowGroupMembersViewController : OWSTableViewController

- (void)configWithThread:(TSGroupThread *)thread;

@end
