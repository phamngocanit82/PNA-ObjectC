#import <Foundation/Foundation.h>
#import "MainController.h"
@interface UtilsController : NSObject
@property (strong, nonatomic) MainController *mainController;
+(instancetype)sharedInstance;

-(void)initViewController;

-(NSObject*)getController;

-(NSObject*)getControllerWithName:(NSString*)name;

-(NSObject*)getControllerFromStoryboard:(NSString*)restorationIdentifier Storyboard:(NSString*)strStoryboard;

-(NSObject*)getControllerFromTabbar:(NSString*)name navigation:(UINavigationController*)navigationController;

-(NSObject*)push:(NSString*)restorationIdentifier Storyboard:(NSString*)strStoryboard Animated:(BOOL)animated;

-(void)pop:(NSString*)controller Animated:(BOOL)animated;

-(void)back:(BOOL)animated;

-(void)root:(BOOL)animated;
@end
