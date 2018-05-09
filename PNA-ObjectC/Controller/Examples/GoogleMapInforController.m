//
//  GoogleMapInforController.m
//  PNA-ObjectC
//
//  Created by An on 5/9/18.
//  Copyright © 2018 An. All rights reserved.
//

#import "GoogleMapInforController.h"

@interface GoogleMapInforController ()

@end

@implementation GoogleMapInforController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)loadData:(NSMutableDictionary*)dic{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [self.view updateConstraints];
        [self.view updateConstraintsIfNeeded];
    }
    self.inforLabel.text = [dic valueForKey:@"address"];
    NSLog(@"%@",dic);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
