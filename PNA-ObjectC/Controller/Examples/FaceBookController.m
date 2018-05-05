//
//  FaceBookController.m
//  PNA-ObjectC
//
//  Created by An on 5/2/18.
//  Copyright © 2018 An. All rights reserved.
//

#import "FaceBookController.h"

@interface FaceBookController ()

@end

@implementation FaceBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionLogin:(id)sender{
    [UtilsFaceBook.sharedInstance actionLogin:self withComplete:^(NSMutableDictionary *response) {
        if([response objectForKey:@"name"]){
            self.nameLabel.text = [response objectForKey:@"name"];
        }
        if([response objectForKey:@"email"]){
            self.emailLabel.text = [response objectForKey:@"email"];
        }
        if([response objectForKey:@"picture"]){
            [self.imgView imageWithPath: [[[response objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
        }
    } withError:^{
        
    }];
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
