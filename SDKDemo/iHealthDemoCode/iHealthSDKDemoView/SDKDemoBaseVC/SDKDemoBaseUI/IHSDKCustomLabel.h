//
//  IHSDKCustomLabel.h
//  iHealthDemoCode
//
//  Created by jing on 2023/4/11.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    IHSDKVerticalAlignmentTop = 0,
    IHSDKVerticalAlignmentMiddle,
    IHSDKVerticalAlignmentBottom,
} IHSDKVerticalAlignment;

NS_ASSUME_NONNULL_BEGIN

@interface IHSDKCustomLabel : UILabel

@property (nonatomic) IHSDKVerticalAlignment verticalAlignment;//default:top
@property (nonatomic) CGFloat linespace;// default:0

@end

NS_ASSUME_NONNULL_END
