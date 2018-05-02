//
//  MenuController.m
//  PNA-ObjectC
//
//  Created by An on 4/21/18.
//  Copyright © 2018 An. All rights reserved.
//

#import "MenuController.h"
#import "ExampleController.h"
@interface MenuController ()

@end

@implementation MenuController
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender{
    if([sender isKindOfClass:[UITableViewCell class]]){
        UINavigationController *navController = segue.destinationViewController;
        ExampleController *exampleController = [navController childViewControllers].firstObject;
        if([exampleController isKindOfClass:[ExampleController class]]){
            //exampleController.view.backgroundColor = [UIColor redColor];
        }
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    switch ( indexPath.row ){
        case 0:
            CellIdentifier = @"map";
            break;
        case 1:
            CellIdentifier = @"example";
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    return cell;
}
@end
