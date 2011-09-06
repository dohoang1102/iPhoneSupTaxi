//
//  GoogleServiceDirectionsManager.h
//  SupTaxi
//
//  Created by DarkAn on 9/6/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleServiceDirectionsManagerDelegate.h"
#import <MapKit/MapKit.h>

@interface GoogleServiceDirectionsManager : NSObject {
    
}

@property (nonatomic, assign) id<GoogleServiceDirectionsManagerDelegate> delegate;
@property (nonatomic, retain) NSMutableData *dataFromConnection;

-(id)initWithDelegate:(id<GoogleServiceDirectionsManagerDelegate>)googleServiceManagerDelegate;

-(void)calculateRoutesFrom:(CLLocationCoordinate2D)from to: (CLLocationCoordinate2D)to;

@end
