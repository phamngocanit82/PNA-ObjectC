//
//  GoogleMapInforController.h
//  PNA-ObjectC
//
//  Created by An on 5/9/18.
//  Copyright © 2018 An. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoogleMapInforController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *inforLabel;
-(void)loadData:(NSMutableDictionary*)dic;
@end
