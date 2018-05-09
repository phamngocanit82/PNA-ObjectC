//
//  UtilsGoogleMap.m
//  PNA-ObjectC
//
//  Created by An on 5/5/18.
//  Copyright © 2018 An. All rights reserved.
//

#define KEY_GOOGLE_MAP @"AIzaSyD8X-vKJ3-eMGQNiyCA-B6T5faB3dJMTCE"
#define API_GOOGLE_GET_INFOR @"https://maps.googleapis.com/maps/api/geocode/json?"
#define DEFAULT_LATITUDE 10.783000716441
#define DEFAULT_LONGTITUDE 106.6972613435
@interface UtilsGoogleMap ()
@property (strong, nonatomic) ConnectionService *connectionService;
@end
@implementation UtilsGoogleMap
+(instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [GMSServices provideAPIKey:KEY_GOOGLE_MAP];
    });
    return sharedInstance;
}
-(void)mapWithGPS:(NSObject*)object Rect:(CGRect)rect Delegate:(id)delegate{
    if (!_connectionService)
        _connectionService = [[ConnectionService alloc] init];
    [self clear];
    self.delegate = delegate;
    self.isTapped = NO;
    self.isMoving = NO;
    self.isAfterMovement = NO;
    isGPS = FALSE;
    self.gmsMapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) camera:[GMSCameraPosition cameraWithLatitude:self.latitude longitude:self.longitude zoom:12]];
    self.gmsMapView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    self.gmsMapView.myLocationEnabled = YES;
    self.gmsMapView.delegate = self;
    [self resetLocation];
    
    NSString *str = NSStringFromClass([object class]);
    if ([object isKindOfClass:[UIViewController class]])
    str = @"UIViewController";
    NSArray *items = @[@"UIViewController", @"UIView", @"CustomView"];
    NSInteger index = [items indexOfObject:str];
    switch (index) {
            case 0:{
                UIViewController *viewController = (UIViewController*)object;
                [viewController.view addSubview:self.gmsMapView];
                containView = viewController.view;
                break;
            }
            break;
            case 1:
            case 2:{
                UIView *view = (UIView*)object;
                [view addSubview:self.gmsMapView];
                containView = view;
            }
            break;
    }
    [self.gmsMapView setMapType:kGMSTypeNormal];
    if (![CLLocationManager locationServicesEnabled]){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }else{
        self.latitude = DEFAULT_LATITUDE;
        self.longitude = DEFAULT_LONGTITUDE;
        _connectionService.strUrlRequest = [NSString stringWithFormat:@"%@latlng=%f,%f&sensor=true",API_GOOGLE_GET_INFOR, self.latitude, self.longitude];
        NSLog(@"%@",_connectionService.strUrlRequest);
        [_connectionService postDataToServer:nil localDatabase:NO withLocalDatabase:^(NSMutableDictionary *response) {
        } withComplete:^(NSMutableDictionary *response) {
            [self setGMSMapView:response];
        } withError:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail)]) {
                [self.delegate requestFail];
            }
        }];
    }
    if(_connectionService){
        if ([_connectionService.response objectForKey:@"results"]>0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestComplete)]) {
                [self.delegate requestComplete];
            }
        }
    }
}
-(void)setGMSMapView:(NSMutableDictionary*)response{
    /*NSMutableArray *results = [response objectForKey:@"results"];
    if ([results count]>0) {
        results = [[results objectAtIndex:0] valueForKey:@"address_components"];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        if ([results count]>4) {
            marker.title = [[results objectAtIndex:4] valueForKey:@"long_name"];
            marker.snippet = [[results objectAtIndex:3] valueForKey:@"long_name"];
        }
        marker.map = self.gmsMapView;
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestComplete)]) {
            [self.delegate requestComplete];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail)]) {
            [self.delegate requestFail];
        }
    }*/
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestComplete)]) {
        [self.delegate requestComplete];
    }
}
-(void)setLocation:(CLLocationCoordinate2D)loc{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:loc.latitude
                                                            longitude:loc.longitude
                                                                 zoom:14];
    self.gmsMapView.camera = camera;
}
-(void)updateCamera:(CLLocationCoordinate2D)loc{
    CLLocationCoordinate2D loc1 = CLLocationCoordinate2DMake(loc.latitude, loc.longitude);
    CLLocationCoordinate2D loc2 = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:loc1 coordinate:loc2];
    GMSCameraPosition *camera = [self.gmsMapView cameraForBounds:bounds insets:UIEdgeInsetsZero];
    self.gmsMapView.camera = camera;
    [self.gmsMapView animateToZoom:self.gmsMapView.camera.zoom-0.8f];
}
-(void)resetLocation{
    [self.gmsMapView clear];
    [self.gmsMapView setCamera:[GMSCameraPosition cameraWithLatitude:self.latitude longitude:self.longitude zoom:12.0f]];
    [self.gmsMapView setMapType:kGMSTypeNormal];
    NSMutableArray *arrResult = [_connectionService.response objectForKey:@"results"];
    if ([arrResult count]>0) {
        arrResult = [[arrResult objectAtIndex:0]valueForKey:@"address_components"];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        if ([arrResult count]>4) {
            marker.title = [[arrResult objectAtIndex:4] valueForKey:@"long_name"];
            marker.snippet = [[arrResult objectAtIndex:3] valueForKey:@"long_name"];
        }
        marker.map = self.gmsMapView;
    }
}
-(NSArray*)calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false&avoid=highways&mode=driving",saddr,daddr]];
    NSError *error=nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: &error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONWritingPrettyPrinted error:nil];
    return [self decodePolyLine:[self parseResponse:dic]];
}
-(NSString *)parseResponse:(NSDictionary *)response {
    NSArray *routes = [response objectForKey:@"routes"];
    NSDictionary *route = [routes lastObject];
    if (route) {
        NSString *overviewPolyline = [[route objectForKey:@"overview_polyline"] objectForKey:@"points"];
        return overviewPolyline;
    }
    return @"";
}
-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr {
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    [encoded appendString:encodedStr];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\" options:NSLiteralSearch range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            if (index>=len) {
                break;
            }else{
                b = [encoded characterAtIndex:index++] - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            }
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1)
                          : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            if (index>=len){
                break;
            }else{
                b = [encoded characterAtIndex:index++] - 63;
                result |= (b & 0x1f) << shift;
                shift += 5;
            }
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1)
                          : (result >> 1));
        lng += dlng;
        NSNumber *_latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *_longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:
                                [_latitude floatValue] longitude:[_longitude floatValue]];
        [array addObject:location];
    }
    return array;
}
-(void)drawDirection:(CLLocationCoordinate2D)source and:(CLLocationCoordinate2D) dest{
    GMSPolyline *polyline = [[GMSPolyline alloc] init];
    GMSMutablePath *path = [GMSMutablePath path];
    NSArray * points = [self calculateRoutesFrom:source to:dest];
    NSInteger numberOfSteps = points.count;
    for (NSInteger index = 0; index < numberOfSteps; index++){
        CLLocation *location = [points objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        [path addCoordinate:coordinate];
    }
    polyline.path = path;
    polyline.strokeColor = [UIColor colorWithRed:44/255.f green:139/255.f blue:255/255.f alpha:1];
    polyline.strokeWidth = 2.f;
    polyline.map = self.gmsMapView;
    polyline = [polyline copy];
    polyline.strokeColor = [UIColor colorWithRed:44/255.f green:139/255.f blue:255/255.f alpha:1];
    polyline.geodesic = YES;
    polyline.map = self.gmsMapView;
}
-(double)distance:(CLLocationCoordinate2D)coordinate{
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLLocationDistance dis = [loc1 distanceFromLocation:loc2];
    return dis;
}
-(void)loadGPS{
    isGPS = FALSE;
    if ([CLLocationManager locationServicesEnabled]){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    _connectionService.strUrlRequest = [NSString stringWithFormat:@"%@latlng=%f,%f&sensor=true", API_GOOGLE_GET_INFOR, self.latitude, self.longitude];
    [_connectionService postDataToServer:nil localDatabase:NO withLocalDatabase:^(NSMutableDictionary *response) {
    } withComplete:^(NSMutableDictionary *response) {
    } withError:^{
    }];
    [self.gmsMapView clear];
    [self.gmsMapView setCamera:[GMSCameraPosition cameraWithLatitude:self.latitude longitude:self.longitude zoom:12.0f]];
    [self.gmsMapView setMapType:kGMSTypeNormal];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (!isGPS) {
        isGPS = TRUE;
        self.latitude = newLocation.coordinate.latitude;
        self.longitude = newLocation.coordinate.longitude;
        [self.gmsMapView clear];
        [self.gmsMapView setCamera:[GMSCameraPosition cameraWithLatitude:self.latitude longitude:self.longitude zoom:12.0f]];
        [self.gmsMapView setMapType:kGMSTypeNormal];
        _connectionService.strUrlRequest = [NSString stringWithFormat:@"%@latlng=%f,%f&sensor=true", API_GOOGLE_GET_INFOR, newLocation.coordinate.latitude, newLocation.coordinate.longitude];
        [_connectionService postDataToServer:nil localDatabase:NO withLocalDatabase:^(NSMutableDictionary *response) {
        } withComplete:^(NSMutableDictionary *response) {
            [self setGMSMapView:response];
        } withError:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestFail)]) {
                [self.delegate requestFail];
            }
        }];
    }
}
-(BOOL)mapView:(GMSMapView *)mapVieW didTapMarker:(GMSMarker *)marker{
    self.isTapped = YES;
    if([self.viewController.view isDescendantOfView:containView]) {
        [self.viewController.view removeFromSuperview];
        self.viewController = nil;
    }else{
        if ([self.currentGMSMarker isEqual:marker]) {
            self.viewController = (GoogleMapInforController*)[[UtilsController sharedInstance] getControllerFromStoryboard:@"GoogleMapInforVC" Storyboard:@"Examples"];
            CGPoint markerPoint = [self.gmsMapView.projection pointForCoordinate:self.currentGMSMarker.position];
            self.viewController.view.frame = CGRectMake(markerPoint.x-120/2, markerPoint.y, 120, 50);
            [self.viewController loadData:self.currentGMSMarker.userData];
            [containView addSubview:self.viewController.view];
        }else{
            self.currentGMSMarker = nil;
        }
    }
    self.currentGMSMarker = marker;
    if (![self.currentGMSMarker isEqual:marker]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTapMarker:)]) {
            [self.delegate didTapMarker:marker.userData];
        }
    }
    GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:marker.position];
    [self.gmsMapView animateWithCameraUpdate:cameraUpdate];
    return YES;
}
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate;{
    if([self.viewController.view isDescendantOfView:containView]) {
        [self.viewController.view removeFromSuperview];
        self.viewController = nil;
    }
}
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    if(self.isAfterMovement) {
        if([self.viewController.view isDescendantOfView:containView]) {
            [self.viewController.view removeFromSuperview];
            self.viewController = nil;
        }
    }
    if(self.isTapped)
        self.isMoving = YES;
}
- (void)mapView:(GMSMapView *)mapVieW idleAtCameraPosition:(GMSCameraPosition *)position{
    if(self.isTapped && self.isMoving&&self.viewController==nil) {
        self.isMoving = NO;
        self.isTapped = NO;
        self.isAfterMovement = YES;
        
        self.viewController = (GoogleMapInforController*)[[UtilsController sharedInstance] getControllerFromStoryboard:@"GoogleMapInforVC" Storyboard:@"Examples"];
        CGPoint markerPoint = [self.gmsMapView.projection pointForCoordinate:self.currentGMSMarker.position];
        self.viewController.view.frame = CGRectMake(markerPoint.x-120/2, markerPoint.y, 120, 50);
        [self.viewController loadData:self.currentGMSMarker.userData];
        [containView addSubview:self.viewController.view];
    }
}
-(void)removeAllItemsInView{
    if([self.viewController.view isDescendantOfView:containView]) {
        [self.viewController.view removeFromSuperview];
        self.viewController = nil;
        isMoved = YES;
        self.isMoving = YES;
    }
}
-(void)clearMakers{
    [self.gmsMapView clear];
    NSMutableArray *results = [_connectionService.response objectForKey:@"results"];
    if ([results count]>0) {
        results = [[results objectAtIndex:0]valueForKey:@"address_components"];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        if ([results count]>4) {
            marker.title = [[results objectAtIndex:4] valueForKey:@"long_name"];
            marker.snippet = [[results objectAtIndex:3] valueForKey:@"long_name"];
        }
        marker.map = self.gmsMapView;
    }
}
-(void)clear{
    if (self.gmsMapView) {
        [self.gmsMapView clear] ;
        [self.gmsMapView stopRendering] ;
        [self.gmsMapView removeFromSuperview] ;
        self.gmsMapView = nil ;
        self.delegate = nil;
    }
}
@end
