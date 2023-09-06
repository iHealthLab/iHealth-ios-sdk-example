//
//  IHSDKHomeTabBarController.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/5/30.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "IHSDKHomeTabBarController.h"

#import "IHSDKBaseNavigationController.h"
#import "IHSDKBaseController.h"
#import "IHSDKMeasureVC.h"
#import "IHSDKDataVC.h"
#import "IHSDKGeneralVC.h"

@interface IHSDKHomeTabBarController ()<UITabBarDelegate>

@end

@implementation IHSDKHomeTabBarController

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
    IHSDKMeasureVC *measureVC = [IHSDKMeasureVC new];
    IHSDKBaseNavigationController *measureNav = [self addChildVC:measureVC title:NSLocalizedString(@"Device", @"") image:[UIImage imageNamed:@"tab_device_normal"] selectImage:[UIImage imageNamed:@"tab_device_select"]];
    
    IHSDKDataVC *dataVC = [IHSDKDataVC new];
    IHSDKBaseNavigationController *dataNav = [self addChildVC:dataVC title:NSLocalizedString(@"Data", @"") image:[UIImage imageNamed:@"tab_data_normal"] selectImage:[UIImage imageNamed:@"tab_data_select"]];
    
    
    IHSDKGeneralVC *genVC = [IHSDKGeneralVC new];
    IHSDKBaseNavigationController *genNav = [self addChildVC:genVC title:NSLocalizedString(@"General", @"") image:[UIImage imageNamed:@"tab_gen_normal"] selectImage:[UIImage imageNamed:@"tab_gen_select"]];
    
    self.viewControllers = @[measureNav, dataNav, genNav];
}


- (IHSDKBaseNavigationController *)addChildVC:(IHSDKBaseController *)childVC title:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage{
    
    [childVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:IHSDKScaleByWidth(12)]} forState:UIControlStateNormal];

    
    childVC.navigationBar.leftItem.hidden = YES;
    childVC.vcTitle = title;
    childVC.navigationBar.rightItem.hidden = YES;
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    childVC.title = title;
    childVC.tabBarItem.image = image;
    childVC.tabBarItem.selectedImage = selectImage;
    
    IHSDKBaseNavigationController *nav = [[IHSDKBaseNavigationController alloc]initWithRootViewController:childVC];
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
