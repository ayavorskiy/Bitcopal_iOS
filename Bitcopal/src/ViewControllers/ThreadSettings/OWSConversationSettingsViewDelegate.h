//
//  Created by Ilya Kostyukevich. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@class TSGroupModel;

@protocol OWSConversationSettingsViewDelegate <NSObject>

- (void)groupWasUpdated:(TSGroupModel *)groupModel;

- (void)popAllConversationSettingsViews;

@end

NS_ASSUME_NONNULL_END
