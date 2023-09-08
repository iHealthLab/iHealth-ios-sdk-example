//
//  BG1AHomeTabBarController.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/5/31.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKBG1AHomeTabBarController.h"

#import "IHSDKBG1ABaseNavigationController.h"

#import "IHSDKBG1ABaseController.h"

#import "IHSDKBG1AMeasureVC.h"

#import "IHSDKBG1ADataVC.h"

#import "IHSDKBG1ASettingVC.h"

@interface IHSDKBG1AHomeTabBarController ()<UITabBarDelegate>

@end

@implementation IHSDKBG1AHomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setTranslucent:NO];
    
    [self setup];
    [self showTabbar];
    
}

- (void)setup {
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
}

- (void)showTabbar{
    IHSDKBG1AMeasureVC *measureVC = [IHSDKBG1AMeasureVC new];
    IHSDKBG1ABaseNavigationController *measureNav = [self addChildVC:measureVC title:NSLocalizedString(@"Measure", @"") image:[UIImage imageNamed:@"bg1a_tab_measure_normal"] selectImage:[UIImage imageNamed:@"bg1a_tab_measure_select"]];
    
    IHSDKBG1ADataVC *dataVC = [IHSDKBG1ADataVC new];
    IHSDKBG1ABaseNavigationController *dataNav = [self addChildVC:dataVC title:NSLocalizedString(@"Data", @"") image:[UIImage imageNamed:@"bg1a_tab_data_normal"] selectImage:[UIImage imageNamed:@"bg1a_tab_data_select"]];


    IHSDKBG1ASettingVC *settingVC = [IHSDKBG1ASettingVC new];
    IHSDKBG1ABaseNavigationController *settingNav = [self addChildVC:settingVC title:NSLocalizedString(@"Setting", @"") image:[UIImage imageNamed:@"bg1a_tab_setting_normal"] selectImage:[UIImage imageNamed:@"bg1a_tab_setting_select"]];
    
    self.viewControllers = @[measureNav,dataNav,settingNav];
}


- (IHSDKBG1ABaseNavigationController *)addChildVC:(IHSDKBG1ABaseController *)childVC title:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage{
    
    [childVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:IHSDKScaleByWidth(12) weight:UIFontWeightBold]} forState:UIControlStateNormal];

    
    childVC.navigationBar.leftItem.hidden = YES;
    childVC.vcTitle = title;
    childVC.navigationBar.rightItem.hidden = YES;
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    childVC.title = title;
    childVC.tabBarItem.image = image;
    childVC.tabBarItem.selectedImage = selectImage;
    
    IHSDKBG1ABaseNavigationController *nav = [[IHSDKBG1ABaseNavigationController alloc]initWithRootViewController:childVC];
    nav.navigationBar.hidden = YES;
    return nav;
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [[NSNotificationCenter defaultCenter] postNotificationName:IHSDKPassReloadToTopNotiName object:nil];
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
