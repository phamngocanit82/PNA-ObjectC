//
//  AppDelegate.h
//  PNA-ObjectC
//
//  Created by An on 4/17/18.
//  Copyright © 2018 An. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (assign) BOOL fullScreenYouTube;
           
- (void)saveContext;


@end

