//
//  UtilsGoogleMap.h
//  PNA-ObjectC
//
//  Created by An on 5/5/18.
//  Copyright © 2018 An. All rights reserved.
//
#import <GoogleMaps/GoogleMaps.h>
#import <Foundation/Foundation.h>
#import "GoogleMapInforController.h"
@class UtilsGoogleMap;
@protocol UtilsGoogleMapDelegate <NSObject>
-(void)requestComplete;
-(void)requestFail;
-(void)didTapMarker:(NSDictionary*)dic;
@end
@interface UtilsGoogleMap : NSObject<CLLocationManagerDelegate,GMSMapViewDelegate>{
    UIView *containView;
    CLLocationManager *locationManager;
    BOOL isMoved;
    BOOL isGPS;
}
@property (weak) id<UtilsGoogleMapDelegate> delegate;
@property (strong, nonatomic) IBOutlet GMSMapView *gmsMapView;
@property (strong, nonatomic) GMSMarker *currentGMSMarker;
@property (strong, nonatomic) GoogleMapInforController *viewController;
@property (assign) BOOL isTapped;
@property (assign) BOOL isMoving;
@property (assign) BOOL isAfterMovement;
@property (assign) double latitude;
@property (assign) double longitude;
+(instancetype)sharedInstance;
-(void)mapWithGPS:(NSObject*)object Rect:(CGRect)rect Delegate:(id)delegate;
-(GMSMapView*)getGMSMapView;
-(void)setLocation:(CLLocationCoordinate2D)loc;
-(void)updateCamera:(CLLocationCoordinate2D)loc;
-(void)resetLocation;
-(void)drawDirection:(CLLocationCoordinate2D)source and:(CLLocationCoordinate2D) dest;
-(double)distance:(CLLocationCoordinate2D)coordinate;
-(void)loadGPS;
-(void)removeItemView;
-(void)clearMakers;
-(void)clear;
@end
