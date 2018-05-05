//
//  UtilsFaceBook.m
//  PNA-ObjectC
//
//  Created by An on 5/5/18.
//  Copyright © 2018 An. All rights reserved.
//

#import "UtilsFaceBook.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@implementation UtilsFaceBook
+(instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(void)actionLogin:(UIViewController*)viewController withComplete:(void(^) (NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    self.callbackComplete = callComplete;
    self.callbackError = callError;
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    if (FBSDKAccessToken.currentAccessToken!=nil){
        [loginManager logOut];
    }
    loginManager.loginBehavior = FBSDKLoginBehaviorNative;
    [loginManager logInWithReadPermissions:@[@"public_profile", @"email"]
        fromViewController:viewController
        handler:^(FBSDKLoginManagerLoginResult *result, NSError *error){
            if(!error){
                if([result.grantedPermissions containsObject:@"email"]){
                    [self getProfile];
                    [loginManager logOut];
                }
            }else{
                self.callbackError();
            }
    }];
}
-(void)getProfile{
    if (FBSDKAccessToken.currentAccessToken!=nil){
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, picture.type(large), email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error){
             if (!error){
                 self.callbackComplete(result);
             }else{
                 self.callbackError();
             }
         }];
    }
}
@end
