//
//  AditionalPrecompileds.h
//  
//
//  Created by Eugene Zavalko on 18.10.10.
//  Copyright 2010 EaZySoft. All rights reserved.
//


#ifndef __ADITIONALPRECOMPILEDS_H__
#define __ADITIONALPRECOMPILEDS_H__

#import <sys/types.h>

@interface NSString (md5)

+ (NSString *) md5String:(NSString *)str;
+ (NSUInteger) md5:(NSString *)str;

@end

@interface NSData (md5)

- (NSString *) md5String;
- (NSUInteger) md5;

@end



@interface UIColor (byteRGBA)

+ (UIColor *) colorWithRedByte:(unsigned char)red 
					 greenByte:(unsigned char)green 
					  blueByte:(unsigned char)blue 
					 alphaByte:(unsigned char)alpha;

+ (UIColor *) colorWithRedByte:(unsigned char)red 
					 greenByte:(unsigned char)green 
					  blueByte:(unsigned char)blue;

+ (UIColor *) colorWithHEXString:(NSString *)hexString;

+ (UIColor *) colorWithHEXCString:(const char *)hexCString;

@end


@interface NSArray(isEmpty)

+ (BOOL) IsEmpty:(NSArray*)arrayForChecking;
+ (BOOL) IsNotEmpty:(NSArray*)arrayForChecking;
- (BOOL) IsValidIndex:(NSUInteger)ind;

@end


@interface UIImage(ScaleProportionaly)

- (UIImage *) ImageByScalingWithSizeFactor:(CGSize)scaleFactor;
- (UIImage *) ImageByScalingProportionallyToNewWidth:(CGFloat)newWidth;
- (UIImage *) ImageByScalingProportionallyToNewHeight:(CGFloat)newHeight;

@end


@interface UIImage(interfaceOrientation)

- (UIImage *) UpOrientationImage;

@end

@interface UIView(screenshot)

- (UIImage *) screenshotImage;

@end

@interface NSDate(SQLite)

- (NSString *) sqlStringRepresentation;

@end

@interface UIScrollView(VisibleRect)

- (CGRect) visibleRect;

@end


@interface NSString(containes)

- (BOOL) isContainesSubstring:(NSString *)subStr;
- (NSString *) MaskSingleQuote;
- (NSString *) ExpandCharacterEntities;
+ (BOOL) IsEmpty:(NSString *)s;
+ (BOOL) IsNotEmpty:(NSString *)s;

@end


/* pi/180 */
#ifndef MATH_PI_DIV_180
#define MATH_PI_DIV_180 (0.017453292519943295769236907684886) 
#endif

/* 180/pi */
#ifndef MATH_RADIAN
#define MATH_RADIAN (57.295779513082320876798154814105) 
#endif

/* 180/pi */
#ifndef MATH_180_DIV_PI
#define MATH_180_DIV_PI MATH_RADIAN 
#endif

#ifndef DEG_TO_RAD
#define DEG_TO_RAD(a) (a*MATH_PI_DIV_180)
#endif

#ifndef RAD_TO_DEG
#define RAD_TO_DEG(a) (a*MATH_180_DIV_PI)
#endif

#ifndef IS_HORIZONTAL_ORIENTATION
#define IS_HORIZONTAL_ORIENTATION(o) ((o==UIInterfaceOrientationLandscapeLeft)||(o==UIInterfaceOrientationLandscapeRight))
#endif

#ifndef IS_VERTICAL_ORIENTATION
#define IS_VERTICAL_ORIENTATION(o) ((o==UIInterfaceOrientationPortrait)||(o==UIInterfaceOrientationPortraitUpsideDown))
#endif

#ifndef CURRENT_DEVICE_ORIENTATION
#define CURRENT_DEVICE_ORIENTATION ([[UIApplication sharedApplication] statusBarOrientation])
#endif

#ifndef NSUInteger64
typedef uint64_t NSUInteger64;
#endif

#ifndef NSInteger64
typedef int64_t NSInteger64;
#endif

#ifndef SAFE_REASSIGN
#define SAFE_REASSIGN(to,from) {if(to){[to release];to=nil;};if(from){to=[from retain];};}
#endif

#ifndef SAFE_RELEASE
#define SAFE_RELEASE(o) if(o){[o release];o=nil;}
#endif

#endif

