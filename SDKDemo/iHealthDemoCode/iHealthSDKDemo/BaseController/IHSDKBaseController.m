//
//  IHSDKBaseController.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/5/28.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKBaseController.h"

@interface IHSDKBaseController ()

@end

@implementation IHSDKBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:self.navigationBar];
}

- (void)setVcTitle:(NSString *)vcTitle {
    _vcTitle = vcTitle;
    self.navigationBar.titleLab.text = NSLocalizedString(vcTitle, @"");
}

- (void)leftItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemAction {
    
}

- (IHSDKNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[IHSDKNavigationBar alloc] init];
        @weakify(self)
        _navigationBar.leftItemBlock = ^{
            @strongify(self)
            [self leftItemAction];
        };
        _navigationBar.rightItemBlock = ^{
            @strongify(self)
            [self rightItemAction];
        };
    }
    return _navigationBar;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
