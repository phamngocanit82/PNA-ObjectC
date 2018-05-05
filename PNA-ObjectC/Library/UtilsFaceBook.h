//
//  UtilsFaceBook.h
//  PNA-ObjectC
//
//  Created by An on 5/5/18.
//  Copyright © 2018 An. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilsFaceBook : NSObject
+(instancetype)sharedInstance;
@property (copy, nonatomic) void (^ callbackComplete)(NSMutableDictionary *response);
@property (copy, nonatomic) void (^ callbackError)(void);
-(void)actionLogin:(UIViewController*)viewController withComplete:(void(^) (NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
-(void)getProfile;
@end
