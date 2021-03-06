//
//  MapViewBaseBar.h
//  SupTaxi
//
//  Created by DarkAn on 9/4/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewSearchBarDelegate.h"
#import "GoogleServiceManagerDelegate.h"
#import "GoogleResultPlacemark.h"
#import "GoogleServiceManager.h"
#import "KnownAddressesDelegate.h"

@interface MapViewBaseBar : UIViewController <GoogleServiceManagerDelegate> {
    
}

@property (nonatomic, assign) id<MapViewSearchBarDelegate> delegate;
@property (nonatomic, assign) id<KnownAddressesDelegate> knownAddressesDelegate;

@property (nonatomic, retain) IBOutlet UIButton *hideButton;

@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, retain) GoogleServiceManager *googleManager;

@property (nonatomic, assign) BOOL requestedCurrentLocation;

@property (nonatomic, retain) NSTimer *blinkTimer;
@property (nonatomic, assign) int blinkCount;

-(void)resignEditFields;
-(NSArray *)placeMarks;
-(void)setFoundPlaceMark:(GoogleResultPlacemark *)placeMark;

-(void)startAddressSearch:(NSString *)address;
-(void)startPlacemarkSearch:(GoogleResultPlacemark *)placeMark;
-(void)onShowRoute;

-(void)initWithSelfLocation;
-(void)onSelfLocationFound:(MKUserLocation *)location;

-(BOOL)validate;
-(void)clearData;

-(NSString *)nameForKnownAdderessByLocation:(CLLocationCoordinate2D)location;

-(IBAction)onHidePressed:(id)sender;

@end
