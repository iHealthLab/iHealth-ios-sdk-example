//
//  IHSDKBaseCell.m
//  iHealthDemoCode
//
//  Created by jing on 2023/4/12.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKBaseCell.h"
#import "IHSDKDemoUIHeader.h"
@implementation IHSDKBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style{
    self = [super initWithStyle:style reuseIdentifier:nil];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.textLabel setValue:IHSDK_FONT_Medium(30) forKey:NSStringFromSelector(@selector(font))];
        [self.detailTextLabel setValue:IHSDK_FONT_Medium(12) forKey:NSStringFromSelector(@selector(font))];
        
        [self.textLabel setValue:kIHSDK_Text_Black forKey:NSStringFromSelector(@selector(textColor))];
        [self.detailTextLabel setValue:kIHSDK_Text_Gray forKey:NSStringFromSelector(@selector(textColor))];
    }
    return self;
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.textLabel setValue:IHSDK_FONT_Medium(14) forKey:NSStringFromSelector(@selector(font))];
        [self.detailTextLabel setValue:IHSDK_FONT_Medium(14) forKey:NSStringFromSelector(@selector(font))];
//        cell.accessoryView = [[UIImageView alloc]initWithImage:WZSImageNamed(@"wzs_right_arrow")];
    }
    return self;
}

+ (instancetype)settingCell{
    IHSDKBaseCell *cell = [[IHSDKBaseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (cell) {
        cell.backgroundColor = UIColor.whiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:KIHSDKImageNamed(@"IHSDK_right_arrow")];
        cell.accessoryView = arrowImageView;
        [cell.textLabel setValue:IHSDK_FONT_Regular(17) forKey:NSStringFromSelector(@selector(font))];
        [cell.detailTextLabel setValue:IHSDK_FONT_Regular(15) forKey:NSStringFromSelector(@selector(font))];
        [cell.textLabel setValue:kIHSDK_Text_Black_2 forKey:NSStringFromSelector(@selector(textColor))];
        [cell.detailTextLabel setValue:kIHSDK_Text_Gray_2 forKey:NSStringFromSelector(@selector(textColor))];
    }
    return cell;
}

+ (instancetype)customCellWithTextFont:(nullable UIFont*)textFont
                             textColor:(nullable UIColor*)textColor
                        detailTextFont:(nullable UIFont*)detailTextFont
                       detailTextColor:(nullable UIColor*)detailTextColor
                   isShowAccessoryView:(BOOL)isShowAccessoryView{
    IHSDKBaseCell *cell = [IHSDKBaseCell settingCell];
    if (textFont) {
        [cell.textLabel setValue:textFont forKey:NSStringFromSelector(@selector(font))];
    }
    if (textColor) {
        [cell.textLabel setValue:textColor forKey:NSStringFromSelector(@selector(textColor))];
    }
    if (detailTextFont) {
        [cell.detailTextLabel setValue:detailTextFont forKey:NSStringFromSelector(@selector(font))];
    }
    if (detailTextColor) {
        [cell.detailTextLabel setValue:detailTextColor forKey:NSStringFromSelector(@selector(textColor))];
    }
    if (isShowAccessoryView==NO) {
        cell.accessoryView = nil;
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEnable:(BOOL)enable{
    if (!enable) {
        [self.textLabel setValue:kIHSDK_Text_Gray_Disable_2 forKey:NSStringFromSelector(@selector(textColor))];
//        [self.detailTextLabel setValue:WZS_Text_Gray forKey:NSStringFromSelector(@selector(textColor))];
    } else {
       [self.textLabel setValue:kIHSDK_Text_Black_2 forKey:NSStringFromSelector(@selector(textColor))];
//        [self.detailTextLabel setValue:WZS_Text_Black forKey:NSStringFromSelector(@selector(textColor))];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 修改删除确认按钮的字体
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            UIView *bgView = (UIView*)[subview.subviews firstObject];
            for (UIView *obj in bgView.subviews) {
                if ([NSStringFromClass([obj class]) isEqualToString:@"UIButtonLabel"]) {
                    UILabel *lab = (UILabel*)obj;
                    lab.font = IHSDK_FONT_Regular(14);
                    break;
                }
            }
            break;
        }
    }
}

- (void)addBottomLineView{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = IHSDK_COLOR_FROM_HEX(0xF0F4F7);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).offset(-1);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(IHSDK_SCREEN_W);

    }];
}

- (void)addNewIconToAccessoryView{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:KIHSDKImageNamed(@"IHSDK_new_version_icon")];
    imageView.contentMode = UIViewContentModeCenter;
    UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:KIHSDKImageNamed(@"IHSDK_right_arrow")];
    arrowImageView.contentMode = UIViewContentModeCenter;
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [container addSubview:imageView];
    [container addSubview:arrowImageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(container);
        make.left.mas_equalTo(container).offset(8);
    }];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(container);
        make.left.mas_equalTo(imageView.mas_right).offset(12);
    }];
    
    self.accessoryView = container;
}
- (void)addIconToAccessoryViewWithImage:(UIImage*)image{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:KIHSDKImageNamed(@"IHSDK_right_arrow")];
    arrowImageView.contentMode = UIViewContentModeCenter;
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [container addSubview:imageView];
    [container addSubview:arrowImageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(container);
        make.left.mas_equalTo(container).offset(8);
    }];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(container);
        make.left.mas_equalTo(imageView.mas_right).offset(12);
    }];
    
    self.accessoryView = container;
}

@end
