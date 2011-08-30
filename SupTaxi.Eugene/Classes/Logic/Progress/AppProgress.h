//
//  AppProgress.h
//  tvjam
//
//  Created by Eugene Zavalko on 7/20/11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#ifndef SAFE_REASSIGN
#define SAFE_REASSIGN(to,from) {if(to){[to release];to=nil;};if(from){to=[from retain];};}
#endif

#ifndef SAFE_RELEASE
#define SAFE_RELEASE(o) if(o){[o release];o=nil;}
#endif

@interface AppProgress : NSObject 
{
@private
	MBProgressHUD * _progressHUD;
	UIView * _windowView;
}

- (BOOL) StartProcessing:(NSString*)message;
- (BOOL) StopProcessing:(NSString*)message andHideTime:(NSTimeInterval)hideTime;

- (void) SetApplicationWindow:(UIView *)windowView;

+ (AppProgress *) GetDefaultAppProgress;
+ (void)ReleaseDefaultAppProgress;

@end
