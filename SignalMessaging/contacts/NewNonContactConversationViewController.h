//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "SelectRecipientViewController.h"

@protocol NewNonContactConversationViewControllerDelegate <NSObject>

- (void)recipientIdWasSelected:(NSString *)recipientId;

@end

#pragma mark -

@interface NewNonContactConversationViewController : SelectRecipientViewController

@property (nonatomic, weak) id<NewNonContactConversationViewControllerDelegate> nonContactConversationDelegate;

@end
