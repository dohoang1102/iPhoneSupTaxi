//
//  GoogleResultPlacemark.h
//  TestMapView
//
//  Created by DarkAn on 9/3/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GoogleResultPlacemark : MKPlacemark{
    BOOL startPoint;
	BOOL coordinatesInitialized;
}

@property (nonatomic, retain) NSString *cityArea;
@property (nonatomic, retain) NSString *cityRegion;
@property (nonatomic, retain) NSString *houseNumber;
@property (nonatomic, retain) NSString *shortAddress;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, assign) BOOL startPoint;
@property (nonatomic, assign) BOOL selfLocation;
@property (nonatomic, assign) BOOL coordinatesInitialized;

@property (nonatomic, retain) NSString *subwayStation;
@property (nonatomic, retain) NSString *busStation;

+(id)googleResultPlaceMarkForSelfLocation;
+(id)googleResultPlaceMarkWithCoordinates:(CLLocationCoordinate2D)coord isStartPoint:(BOOL)isStartPoint;
+(id)googleResultPlaceMarkForSelfLocationWithCoordinates:(CLLocationCoordinate2D)coord startPoint:(BOOL)isStartPoint;
+(id)googleResultPlacemarkWithResponceDictionary:(NSDictionary *)responce;
+(id)googleResultPlaceMarkByGoogleResultPlacemark:(GoogleResultPlacemark *)placeMark;
-(id)initWithResponceDictionary:(NSDictionary *)responce;

-(BOOL)isNameCustom;

-(MKPinAnnotationColor)colorForPin;

-(GoogleResultPlacemark *)clone;

@end
