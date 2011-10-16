//
//  MapViewController.h
//  TestMapView
//
//  Created by DarkAn on 9/2/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapViewBaseBar.h"
#import "MapViewSearchBarDelegate.h"
#import "GoogleServiceDirectionsManager.h"
#import "GoogleServiceDirectionsManagerDelegate.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, MapViewSearchBarDelegate, GoogleServiceDirectionsManagerDelegate> {

}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) MapViewBaseBar *mapViewSearchBar;

@property (nonatomic, retain) UIImageView *routeView;
@property (nonatomic, retain) NSArray *routes;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, assign) BOOL mapManipulationsEnabled;

@property (nonatomic, retain) GoogleServiceDirectionsManager *googleManager;

-(void)initPreferences;
-(void)updateRouteView:(BOOL)shouldResizeMap;
-(void)hideRouteView;

@end
