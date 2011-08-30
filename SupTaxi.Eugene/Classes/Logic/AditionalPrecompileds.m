//
//  AditionalPrecompileds.m
//  
//
//  Created by Eugene Zavalko on 18.10.10.
//  Copyright 2010 EaZySoft. All rights reserved.
//

#import "AditionalPrecompileds.h"

#ifdef __OBJC__

#import <CommonCrypto/CommonDigest.h>
#import <math.h>

@implementation NSString (md5)

+ (NSString *) md5String:(NSString *)str 
{
	if (str != nil)
	{
		unsigned char result[16] = { 0 };
		CC_MD5( (const void*)[str UTF8String],  (CC_LONG)[str length], result );
		return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], 
				result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
	}
	return @"0000000000000000";
}

+ (NSUInteger) md5:(NSString *)str
{
	if (str != nil) 
	{
		NSUInteger result[4] = { 0 };
		CC_MD5( (const void*)[str UTF8String],  (CC_LONG)[str length], (unsigned char*)&result[0] );
		NSUInteger value = (result[0] ^ result[1] ^ result[2] ^ result[3]);
		return value;
	}
	return 0;
}

@end

@implementation NSData (md5)

- (NSString *) md5String
{
	const void * dataBytes = [self bytes];
	CC_LONG dataLength = (CC_LONG)[self length];
	
	if ( dataBytes && dataLength ) 
	{
		unsigned char result[16] = { 0 };
		CC_MD5( dataBytes,  dataLength, result );
		return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], 
				result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
	}
	
	return @"0000000000000000";
}

- (NSUInteger) md5
{
	const void * dataBytes = [self bytes];
	CC_LONG dataLength = (CC_LONG)[self length];
	
	if ( dataBytes && dataLength ) 
	{
		NSUInteger result[4] = { 0 };
		CC_MD5( dataBytes,  dataLength, (unsigned char*)&result[0] );
		NSUInteger value = (result[0] ^ result[1] ^ result[2] ^ result[3]);
		return value;
	}
	
	return 0;
}

@end


@implementation UIColor (byteRGBA)

+ (UIColor *) colorWithRedByte:(unsigned char)red 
					 greenByte:(unsigned char)green 
					  blueByte:(unsigned char)blue 
					 alphaByte:(unsigned char)alpha
{
	UIColor * newColor = [UIColor colorWithRed:((CGFloat)red / (CGFloat)255.0)
										 green:((CGFloat)green / (CGFloat)255.0) 
										  blue:((CGFloat)blue / (CGFloat)255.0) 
										 alpha:((CGFloat)alpha / (CGFloat)255.0)];
	return newColor;
}

+ (UIColor *) colorWithRedByte:(unsigned char)red 
					 greenByte:(unsigned char)green 
					  blueByte:(unsigned char)blue
{
	UIColor * newColor = [UIColor colorWithRed:((CGFloat)red / (CGFloat)255.0)
										 green:((CGFloat)green / (CGFloat)255.0) 
										  blue:((CGFloat)blue / (CGFloat)255.0) 
										 alpha:(CGFloat)1.0];
	return newColor;
}

+ (UIColor *) colorWithHEXString:(NSString *)hexString
{
	if (hexString != nil) 
	{
		return [UIColor colorWithHEXCString:[hexString UTF8String]];
	}
	return nil;
}

+ (UIColor *) colorWithHEXCString:(const char *)hexCString
{
	if (hexCString != nil) 
	{
		if (strlen(hexCString) >= 7) 
		{
			char lowerString[7] = { 0 };
			for (int i = 0; i < 7; i++) 
			{
				lowerString[i] = tolower(hexCString[i]);
			}
			int r, g, b;
			if (sscanf(lowerString, "#%2x%2x%2x", &r, &g, &b) == 3)
			{
				if (r > 255) { r = 255; }
				if (g > 255) { g = 255; }
				if (b > 255) { b = 255; }
				UIColor * newColor = [UIColor colorWithRed:((CGFloat)r / (CGFloat)255.0f)
													 green:((CGFloat)g / (CGFloat)255.0f) 
													  blue:((CGFloat)b / (CGFloat)255.0f) 
													 alpha:1.0f];
				return newColor;
			}
		}
	}
	return nil;
}

@end

@implementation NSArray(isEmpty)

+ (BOOL) IsEmpty:(NSArray*)arrayForChecking
{
	if (arrayForChecking != nil) 
	{
		return ([arrayForChecking count] == 0);
	}
	return YES;
}

+ (BOOL) IsNotEmpty:(NSArray*)arrayForChecking
{
	if (arrayForChecking != nil) 
	{
		return ([arrayForChecking count] > 0);
	}
	return NO;
}

- (BOOL) IsValidIndex:(NSUInteger)ind
{
	return (ind < [self count]);
}

@end


@implementation UIImage(ScaleProportionaly)

- (UIImage *) ImageByScalingWithSizeFactor:(CGSize)scaleFactor
{
	if ( (scaleFactor.width <= 0.0f) || (scaleFactor.height <= 0.0f) ) 
	{
		return self;
	}
	
	const CGSize oldSize = self.size;
	CGSize newSize;
	newSize.width = round(oldSize.width * scaleFactor.width);
	newSize.height = round(oldSize.height * scaleFactor.height);
	
	UIGraphicsBeginImageContext(newSize);
	
	[self drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
	
	UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (UIImage *) ImageByScalingProportionallyToNewWidth:(CGFloat)newWidth
{
	if (newWidth < 1.0f) 
	{
		return self;
	}
	const CGSize oldSize = self.size;
	if (newWidth == oldSize.width) 
	{
		return self;
	}
	const CGFloat scaleFactor = newWidth / oldSize.width;
	return [self ImageByScalingWithSizeFactor:CGSizeMake(scaleFactor, scaleFactor)];
}

- (UIImage *) ImageByScalingProportionallyToNewHeight:(CGFloat)newHeight
{
	if (newHeight < 1.0f) 
	{
		return self;
	}
	const CGSize oldSize = self.size;
	if (newHeight == oldSize.height) 
	{
		return self;
	}
	const CGFloat scaleFactor = newHeight / oldSize.height;
	return [self ImageByScalingWithSizeFactor:CGSizeMake(scaleFactor, scaleFactor)];
}

@end

@implementation UIImage(interfaceOrientation)

- (UIImage *) UpOrientationImage
{
	UIImage * image = self;
	if (image.imageOrientation == UIImageOrientationUp)
	{
		return image;
	}
	
	int kMaxResolution = 320; // Or whatever  
	
	CGImageRef imgRef = image.CGImage;  
	
	CGFloat width = CGImageGetWidth(imgRef);  
	CGFloat height = CGImageGetHeight(imgRef);  
	
	CGAffineTransform transform = CGAffineTransformIdentity;  
	CGRect bounds = CGRectMake(0, 0, width, height);  
	if ( (width > kMaxResolution) || (height > kMaxResolution) ) 
	{  
		CGFloat ratio = width/height;  
		if (ratio > 1) 
		{  
			bounds.size.width = kMaxResolution;  
			bounds.size.height = bounds.size.width / ratio;  
		}  
		else 
		{  
			bounds.size.height = kMaxResolution;  
			bounds.size.width = bounds.size.height * ratio;  
		}  
	}  
	
	CGFloat scaleRatio = bounds.size.width / width;  
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));  
	CGFloat boundHeight;  
	UIImageOrientation orient = image.imageOrientation;  
	
	if (orient == UIImageOrientationUp) //EXIF = 1  
	{
		transform = CGAffineTransformIdentity;  
	}
	else if (orient == UIImageOrientationUpMirrored) //EXIF = 2  
	{
		transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);  
		transform = CGAffineTransformScale(transform, -1.0, 1.0);  
	}
	else if (orient == UIImageOrientationDown) //EXIF = 3  
	{
		transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);  
		transform = CGAffineTransformRotate(transform, M_PI);  
		
	}
	else if (orient == UIImageOrientationDownMirrored) //EXIF = 4  
	{
		transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);  
		transform = CGAffineTransformScale(transform, 1.0, -1.0);  
	}
	else if (orient == UIImageOrientationLeftMirrored) //EXIF = 5  
	{
		boundHeight = bounds.size.height;  
		bounds.size.height = bounds.size.width;  
		bounds.size.width = boundHeight;  
		transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);  
		transform = CGAffineTransformScale(transform, -1.0, 1.0);  
		transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
	}
	else if (orient == UIImageOrientationLeft) //EXIF = 6  
	{
		boundHeight = bounds.size.height;  
		bounds.size.height = bounds.size.width;  
		bounds.size.width = boundHeight;  
		transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);  
		transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
	}
	else if (orient == UIImageOrientationRightMirrored) //EXIF = 7  
	{
		boundHeight = bounds.size.height;  
		bounds.size.height = bounds.size.width;  
		bounds.size.width = boundHeight;  
		transform = CGAffineTransformMakeScale(-1.0, 1.0);  
		transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
	}
	else if (orient == UIImageOrientationRight) //EXIF = 8  
	{
		boundHeight = bounds.size.height;  
		bounds.size.height = bounds.size.width;  
		bounds.size.width = boundHeight;  
		transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);  
		transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
	}
	else
	{
		return self;
	}
	
	UIGraphicsBeginImageContext(bounds.size);  
	
	CGContextRef context = UIGraphicsGetCurrentContext();  
	
	if ( (orient == UIImageOrientationRight) || (orient == UIImageOrientationLeft) ) 
	{  
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}  
	else 
	{  
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}  
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
	UIImage * imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

@end

@implementation UIView(screenshot)

- (UIImage *) screenshotImage
{
	const CGRect selfBounds = [self bounds];
	if (UIGraphicsBeginImageContextWithOptions != NULL)
	{
        UIGraphicsBeginImageContextWithOptions(selfBounds.size, NO, 0);
	}
    else
	{
        UIGraphicsBeginImageContext(selfBounds.size);
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (context == NULL) 
	{
		return nil;
	}
	
	CALayer * selfLayer = [self layer];
	if (selfLayer == NULL) 
	{
		return nil;
	}
	
	//CGContextSaveGState(context);
	//CGContextTranslateCTM(context, [self center].x, [self center].y);
	//CGContextConcatCTM(context, [self transform]);
	//CGContextTranslateCTM(context, -selfBounds.size.width * [selfLayer anchorPoint].x, -selfBounds.size.height * [selfLayer anchorPoint].y);
	[selfLayer renderInContext:context];
	//CGContextRestoreGState(context);
	
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();	
	return image;
}

@end

@implementation NSDate(SQLite)

- (NSString *) sqlStringRepresentation
{
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString * sqlString = [formatter stringFromDate:self];
	[formatter release];
	return sqlString;
}

@end

@implementation UIScrollView(VisibleRect)

- (CGRect) visibleRect
{
	CGRect visibleRect;
	visibleRect.origin = self.contentOffset;
	visibleRect.size = self.bounds.size;
	
	const CGFloat scaleFactor = 1.0f / self.zoomScale;
	if ( isless(scaleFactor, 1.0f) )
	{
		visibleRect.origin.x *= scaleFactor;
		visibleRect.origin.y *= scaleFactor;
		visibleRect.size.width *= scaleFactor;
		visibleRect.size.height *= scaleFactor;
	}
	
	return visibleRect;
}

@end

@implementation NSString(containes)

- (BOOL) isContainesSubstring:(NSString *)subStr
{
	if (subStr != nil) 
	{
		NSRange r = [self rangeOfString:subStr options:NSCaseInsensitiveSearch];
		return ( (r.location != NSNotFound) && (r.length != 0) );
	}
	return NO;
}

- (NSString*) MaskSingleQuote
{
	return [self stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

- (NSString*) ExpandCharacterEntities
{
	NSString	*res = [NSString stringWithString:self];

	// bad sequences
	res = [res stringByReplacingOccurrencesOfString:@"&amp;rsquo;" withString:@"’"];
	res = [res stringByReplacingOccurrencesOfString:@"&amp;nbsp;" withString:@" "];
	
	// good entities
	res = [res stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@"‘"];
	res = [res stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"’"];
	res = [res stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
	res = [res stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
	res = [res stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"…"];
	res = [res stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"–"];
	res = [res stringByReplacingOccurrencesOfString:@"&pound;" withString:@"£"];
	res = [res stringByReplacingOccurrencesOfString:@"&eacute;" withString:@"é"];
	res = [res stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"’"];
	res = [res stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"–"];

	res = [res stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	
	return res;
}

+ (BOOL) IsEmpty:(NSString *)s
{
	if (s) 
	{
		return ([s length] == 0);
	}
	return YES;
}

+ (BOOL) IsNotEmpty:(NSString *)s
{
	if (s) 
	{
		return ([s length] > 0);
	}
	return NO;
}

@end


#endif



