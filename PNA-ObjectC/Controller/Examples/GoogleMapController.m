//
//  GoogleMapController.m
//  PNA-ObjectC
//
//  Created by An on 5/2/18.
//  Copyright © 2018 An. All rights reserved.
//

#import "GoogleMapController.h"

@interface GoogleMapController ()

@end

@implementation GoogleMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UtilsGoogleMap.sharedInstance mapWithGPS:self.view Rect:self.view.frame Delegate:self];
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
- (void)requestComplete{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"map_data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString * json_data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSDictionary dictionaryWithJSONString:json_data error:nil];
    NSMutableArray *list = [dic valueForKey:@"data"];
    
    CLLocationCoordinate2D loc;
    for (NSInteger i=0; i<[list count]; i++) {
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
        iconView.image = [UIImage imageNamed:@"ic_map_red_pin"];
        NSDictionary *shop_location = [[list objectAtIndex:i] valueForKey:@"shop_location"];
        if (i==0) {
            loc.latitude = [[shop_location valueForKey:@"latitude"] doubleValue];
            loc.longitude = [[shop_location valueForKey:@"longitude"] doubleValue];
            [[UtilsGoogleMap sharedInstance] setLocation:loc];
        }
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 37, 34)];
        lbl.font = [UIFont systemFontOfSize:13];
        lbl.textColor = [UIColor whiteColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = [[NSNumber numberWithInteger:i+1] stringValue];
        [iconView addSubview:lbl];
        UIGraphicsBeginImageContextWithOptions(iconView.bounds.size, NO, [[UIScreen mainScreen] scale]);
        [iconView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSNumber numberWithInteger:i] stringValue], @"tag" ,nil];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([[shop_location valueForKey:@"latitude"] doubleValue], [[shop_location valueForKey:@"longitude"] doubleValue]);
        marker.icon = icon;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.userData = [list objectAtIndex:i];
        marker.infoWindowAnchor = CGPointMake(0.3, 0.4);
        marker.map = [[UtilsGoogleMap sharedInstance] gmsMapView];
    }
}
- (void)didTapMarker:(NSDictionary*)dic{
    
}
@end
