//
//  ExampleController.m
//  PNA-ObjectC
//
//  Created by An on 4/21/18.
//  Copyright © 2018 An. All rights reserved.
//

#import "ExampleController.h"

@interface ExampleController ()

@end

@implementation ExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    if (self.revealViewController&&self.menuButton.allTargets.count==1){
        self.revealViewController.rearViewRevealWidth = 150;
        [self.menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.topItem.title = @"Back";
}
@end
