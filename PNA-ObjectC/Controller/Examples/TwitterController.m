//
//  TwitterController.m
//  PNA-ObjectC
//
//  Created by An on 5/2/18.
//  Copyright © 2018 An. All rights reserved.
//

#import "TwitterController.h"
#import <TwitterKit/TWTRKit.h>
@interface TwitterController ()

@end

@implementation TwitterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)actionLogin:(id)sender{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
        [client requestEmailForCurrentUser:^(NSString *email, NSError *error) {
            self.nameLabel.text = session.userName;
            if (email) {
                self.emailLabel.text = email;
            } else {
                self.emailLabel.text = @"This user does not have an email address";
            }
            [self getUser:session.userID];
        }];
    }];
}
-(void)getUser:(NSString*)userId{
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    [client loadUserWithID:userId completion:^(TWTRUser *user, NSError *error) {
         [self.imgView imageWithPath: user.profileImageURL];
    }];
}
@end
