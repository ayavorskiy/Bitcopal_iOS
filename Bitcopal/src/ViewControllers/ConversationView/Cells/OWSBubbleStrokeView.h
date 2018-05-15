//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWSBubbleView.h"

NS_ASSUME_NONNULL_BEGIN

@class OWSBubbleView;

@interface OWSBubbleStrokeView : UIView <OWSBubbleViewPartner>

@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) CGFloat strokeThickness;

@end

NS_ASSUME_NONNULL_END
