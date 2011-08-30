//
//  AppProgress.m
//  tvjam
//
//  Created by Eugene Zavalko on 7/20/11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "AppProgress.h"

#define MESSAGE_STRING_KEY @"mess"
#define HIDE_TIME_NUMBER_KEY @"hdtm"

@interface AppProgress(Private)

- (void) SetDownloadingProgressHidden;
- (void) SetDownloadingProgressHiddenMainThread:(NSNumber *)hideTime;
- (void) SetDownloadingProgressVisible:(BOOL)isVisible;

- (void) SetDownloadingProgressVisibleMainThread:(id)isVisibleObject;
- (void) StartProcessingMainThread:(id)messageObject;
- (void) StopProcessingMainThread:(id)obj;

@end

@implementation AppProgress

static AppProgress * _defaultAppProgress = nil;

- (void)SetDownloadingProgressHidden
{
	[self SetDownloadingProgressVisible:NO];
}

- (void) SetDownloadingProgressHiddenMainThread:(NSNumber *)hideTime
{
	if (hideTime) 
	{
		[self performSelector:@selector(SetDownloadingProgressHidden) 
				   withObject:nil 
				   afterDelay:[hideTime doubleValue]];
	}
}

- (void) SetDownloadingProgressVisibleMainThread:(id)isVisibleObject
{
	NSNumber * n = (NSNumber*)isVisibleObject;
	if ( (_windowView == nil) || (n == nil) ) 
	{
		return;
	}
	
	BOOL isVisible = [n boolValue];
	
	if ( (_progressHUD == nil) && isVisible) 
	{
		_progressHUD = [[MBProgressHUD alloc] initWithView:_windowView];
		
		[_windowView addSubview:_progressHUD];
		
		[_progressHUD show:YES];
	}
	else if ( (_progressHUD != nil) && (!isVisible) )
	{
		[_progressHUD hide:YES];
		[_progressHUD removeFromSuperview];
		[_progressHUD release];
		_progressHUD = nil;
	}
}

- (void) SetDownloadingProgressVisible:(BOOL)isVisible
{
	NSNumber * n = [NSNumber numberWithBool:isVisible];
	if ([NSThread isMainThread]) 
	{
		[self SetDownloadingProgressVisibleMainThread:n];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(SetDownloadingProgressVisibleMainThread:) 
							   withObject:n 
							waitUntilDone:YES];
	}
}

- (void) StartProcessingMainThread:(id)messageObject
{
	_progressHUD.mode = MBProgressHUDModeIndeterminate;
	_progressHUD.labelText = (NSString*)messageObject;
}

- (BOOL) StartProcessing:(NSString *)message
{
	if (_progressHUD == nil) 
	{
		[self SetDownloadingProgressVisible:YES];
	}
	
	if (_progressHUD) 
	{
		if ([NSThread isMainThread]) 
		{
			[self StartProcessingMainThread:message];
		}
		else
		{
			[self performSelectorOnMainThread:@selector(StartProcessingMainThread:) 
								   withObject:message 
								waitUntilDone:YES];
		}
		return YES;
	}
	
	return NO;
}

- (void) StopProcessingMainThread:(id)obj
{
	NSDictionary * d = (NSDictionary*)obj;
	if (d == nil) { return; }
	
	NSString * mess = [d objectForKey:MESSAGE_STRING_KEY];
	NSNumber * num = [d objectForKey:HIDE_TIME_NUMBER_KEY];
	
	if ((mess == nil)||(num == nil)) { return; }
	
	if (_progressHUD) 
	{
		_progressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
		_progressHUD.mode = MBProgressHUDModeCustomView;
		_progressHUD.labelText = mess;
		
		NSTimeInterval hideTime = [num doubleValue];
		if (hideTime > 0.0) 
		{
			if ([NSThread isMainThread]) 
			{
				[self performSelector:@selector(SetDownloadingProgressHidden) 
						   withObject:nil 
						   afterDelay:hideTime];
			}
			else
			{
				[self performSelectorOnMainThread:@selector(SetDownloadingProgressHiddenMainThread:) 
									   withObject:[NSNumber numberWithDouble:hideTime] 
									waitUntilDone:NO];
			}
		}
		else
		{
			[self SetDownloadingProgressHidden];
		}
	}
}

- (BOOL) StopProcessing:(NSString*)message andHideTime:(NSTimeInterval)hideTime
{
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	[d setObject:message forKey:MESSAGE_STRING_KEY];
	[d setObject:[NSNumber numberWithDouble:hideTime] forKey:HIDE_TIME_NUMBER_KEY];
	
	if ([NSThread isMainThread])
	{
		[self StartProcessingMainThread:d];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(StopProcessingMainThread:) 
							   withObject:d 
							waitUntilDone:YES];
	}
	
	return YES;
}

- (void) SetApplicationWindow:(UIView *)windowView
{
	if (_progressHUD) 
	{
		[_progressHUD removeFromSuperViewOnHide];
		[_progressHUD release];
		_progressHUD = nil;
	}
	
	SAFE_REASSIGN(_windowView, windowView);
}

- (id)init
{
	self = [super init];
	if (self) 
	{
		_progressHUD = nil;
		_windowView = nil;
	}
	return self;
}

- (void)dealloc
{
	SAFE_RELEASE(_progressHUD);
	SAFE_RELEASE(_windowView);
	
	[super dealloc];
}

+ (AppProgress*) GetDefaultAppProgress
{
	if (_defaultAppProgress == nil) 
	{
		_defaultAppProgress = [[AppProgress alloc] init];
	}
	return _defaultAppProgress;
}

+ (void)ReleaseDefaultAppProgress
{
	SAFE_RELEASE(_defaultAppProgress);
}

@end
