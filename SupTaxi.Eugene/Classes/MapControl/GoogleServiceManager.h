//
//  GoogleServiceManager.h
//  TestMapView
//
//  Created by DarkAn on 9/2/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleServiceManagerDelegate.h"

@interface GoogleServiceManager : NSObject{

    
}

@property (nonatomic, assign) id<GoogleServiceManagerDelegate> delegate;
@property (nonatomic, retain) NSMutableData *dataFromConnection;

-(id)initWithDelegate:(id<GoogleServiceManagerDelegate>)googleServiceManagerDelegate;

- (void) searchCoordinatesForAddress:(NSString *)inAddress;
-(void)searchCoordinatesbyLongtitude:(double)longitude latitude:(double)latitude;

@end
