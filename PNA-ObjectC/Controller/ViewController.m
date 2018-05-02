//
//  ViewController.m
//  PNA-ObjectC
//
//  Created by An on 4/17/18.
//  Copyright © 2018 An. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<SWRevealViewControllerDelegate>

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.revealViewController){
        self.revealViewController.delegate = self;
        [self.view addGestureRecognizer: self.revealViewController.tapGestureRecognizer];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position{
    UIViewController *controller;
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *nc = (UINavigationController *)revealController.frontViewController;
        controller = (UIViewController *)(nc.topViewController);
    }else{
        controller = revealController.frontViewController;
    }
    if (position == FrontViewPositionLeft) {
        [Utils log:@"FrontViewPositionLeft"];
    }
}

@end
