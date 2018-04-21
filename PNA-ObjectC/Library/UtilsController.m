@implementation UtilsController
+(instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(void)initViewController{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationController = [mainStoryboard instantiateInitialViewController];
    appDelegate.window.rootViewController = navigationController;
    for(UIViewController *viewController in navigationController.viewControllers) {
        if ([NSStringFromClass([viewController class]) isEqualToString:@"MainController"]){
            self.mainController = (MainController*)viewController;
            break;
        }
    }
    [UtilsCache destroyNetworkCache];
}
-(NSObject*)getControllerWithName:(NSString*)name{
    for(UIViewController *ctrl in self.mainController.navigationController.viewControllers) {
        if ([NSStringFromClass([ctrl class]) isEqualToString:name]){
            return ctrl;
            break;
        }
    }
    return nil;
}
-(NSObject*)getController{
    return [self.mainController.navigationController.viewControllers objectAtIndex:[self.mainController.navigationController.viewControllers count]-1];
}
-(NSObject*)getControllerFromStoryboard:(NSString*)restorationIdentifier Storyboard:(NSString*)strStoryboard{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:strStoryboard bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:restorationIdentifier];
    return viewController;
}
-(NSObject*)getControllerFromTabbar:(NSString*)name navigation:(UINavigationController*)navigationController{
    for(UIViewController *ctrl in navigationController.viewControllers) {
        if ([NSStringFromClass([ctrl class]) isEqualToString:name]){
            return ctrl;
            break;
        }
    }
    return nil;
}
-(NSObject*)push:(NSString*)restorationIdentifier Storyboard:(NSString*)strStoryboard Animated:(BOOL)animated{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:strStoryboard bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:restorationIdentifier];
    for(UIViewController *ctrl in self.mainController.navigationController.viewControllers) {
        if ([ctrl.restorationIdentifier isEqualToString:restorationIdentifier]){
            [self.mainController.navigationController popToViewController:ctrl animated:animated];
            return ctrl;
        }
    }
    [self.mainController.navigationController pushViewController:viewController animated:animated];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [viewController.view updateConstraints];
        [viewController.view updateConstraintsIfNeeded];
    }
    return viewController;
}
-(void)pop:(NSString*)controller Animated:(BOOL)animated{
    for(UIViewController *ctrl in self.mainController.navigationController.viewControllers) {
        if ([NSStringFromClass([ctrl class]) isEqualToString:controller]){
            [self.mainController.navigationController popToViewController:ctrl animated:animated];
            break;
        }
    }
}
-(void)back:(BOOL)animated{
    [self.mainController.navigationController popViewControllerAnimated:animated];
}
-(void)root:(BOOL)animated{
    [self.mainController.navigationController popToRootViewControllerAnimated:animated];
}
@end
