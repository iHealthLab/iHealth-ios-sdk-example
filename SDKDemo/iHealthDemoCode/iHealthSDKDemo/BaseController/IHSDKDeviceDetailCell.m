//
//  IHSDKDeviceDetailCell.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/3.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKDeviceDetailCell.h"

@implementation IHSDKDeviceDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style{
    self = [super initWithStyle:style reuseIdentifier:nil];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.textLabel setValue:[UIFont systemFontOfSize:IHSDKScaleByWidth(30)] forKey:NSStringFromSelector(@selector(font))];
        [self.detailTextLabel setValue:[UIFont systemFontOfSize:IHSDKScaleByWidth(12)] forKey:NSStringFromSelector(@selector(font))];
        
        [self.textLabel setValue:[UIColor colorWithHexString:@"#002632"] forKey:NSStringFromSelector(@selector(textColor))];
        [self.detailTextLabel setValue:[UIColor colorWithHexString:@"#7E8D92"] forKey:NSStringFromSelector(@selector(textColor))];
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
        [self.textLabel setValue:[UIFont systemFontOfSize:IHSDKScaleByWidth(14)] forKey:NSStringFromSelector(@selector(font))];
        [self.detailTextLabel setValue:[UIFont systemFontOfSize:IHSDKScaleByWidth(14)] forKey:NSStringFromSelector(@selector(font))];
//        cell.accessoryView = [[UIImageView alloc]initWithImage:WZSImageNamed(@"wzs_right_arrow")];
    }
    return self;
}

+ (instancetype)settingCell{
    IHSDKDeviceDetailCell *cell = [[IHSDKDeviceDetailCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (cell) {
        cell.backgroundColor = UIColor.whiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_arrow_Forward"]];
        cell.accessoryView = arrowImageView;
        [cell.textLabel setValue:[UIFont systemFontOfSize:IHSDKScaleByWidth(17)] forKey:NSStringFromSelector(@selector(font))];
        [cell.detailTextLabel setValue:[UIFont systemFontOfSize:IHSDKScaleByWidth(15)] forKey:NSStringFromSelector(@selector(font))];
        [cell.textLabel setValue:[UIColor colorWithHexString:@"#22262B"] forKey:NSStringFromSelector(@selector(textColor))];
        [cell.detailTextLabel setValue:[UIColor colorWithHexString:@"#515963"] forKey:NSStringFromSelector(@selector(textColor))];
    }
    return cell;
}

+ (instancetype)customCellWithTextFont:(nullable UIFont*)textFont
                             textColor:(nullable UIColor*)textColor
                        detailTextFont:(nullable UIFont*)detailTextFont
                       detailTextColor:(nullable UIColor*)detailTextColor
                   isShowAccessoryView:(BOOL)isShowAccessoryView{
    IHSDKDeviceDetailCell *cell = [IHSDKDeviceDetailCell settingCell];
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
        [self.textLabel setValue:[UIColor colorWithHexString:@"#A8B2BD"] forKey:NSStringFromSelector(@selector(textColor))];
//        [self.detailTextLabel setValue:WZS_Text_Gray forKey:NSStringFromSelector(@selector(textColor))];
    } else {
       [self.textLabel setValue:[UIColor colorWithHexString:@"#22262B"] forKey:NSStringFromSelector(@selector(textColor))];
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
                    lab.font = [UIFont systemFontOfSize:IHSDKScaleByWidth(14)];
                    break;
                }
            }
            break;
        }
    }
}

- (void)addBottomLineView{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F0F4F7"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).offset(-1);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(IHSDKScreen_W);

    }];
}

- (void)addNewIconToAccessoryView{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"IHSDK_new_version_icon"]];
    imageView.contentMode = UIViewContentModeCenter;
    UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_arrow_Forward"]];
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
    UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_arrow_Forward"]];
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

- (void)isShowAccessoryView:(BOOL)isShowAccessoryView{
    
    if (isShowAccessoryView==NO) {
        self.accessoryView = nil;
    }
    
}


@end
