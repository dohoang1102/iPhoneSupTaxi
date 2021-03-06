//
//  OrderShowCell.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "OrderShowCell.h"
#import "UICustomSwitch.h"

@implementation UIOfferImage

@synthesize offer;

- (void)dealloc
{
    [offer release];
    [super dealloc];
}


@end


@implementation OrderShowCell

@synthesize timeLabel;
@synthesize priceLabel;
@synthesize carrierLogo;
@synthesize switcher;

- (UILabel *)newLabel
{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    newLabel.textAlignment = UITextAlignmentLeft;
    newLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
    newLabel.backgroundColor = [UIColor clearColor];
    newLabel.opaque = YES;
    
    return newLabel;
}

- (UIOfferImage *)newImage
{
    UIOfferImage *newImage = [[UIOfferImage alloc] initWithFrame:CGRectZero];
    [newImage setContentMode:UIViewContentModeScaleAspectFit];
    return newImage;
}

- (UICustomSwitch *)newSwitcher
{
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
    UICustomSwitch *newSwitcher = [UICustomSwitch switchWithLeftText:@"I" andRight:@"O"]; 
	[newSwitcher setTintColor: color];
    return [newSwitcher retain];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contexctRect = self.contentView.bounds;
    if (!self.editing) {
        CGFloat boundsX = contexctRect.origin.x;
        CGRect frame;
        
        frame = CGRectMake(boundsX+5, 7.0, 40.0, 20.0);
        self.carrierLogo.frame = frame;
        
        frame = CGRectMake(carrierLogo.frame.origin.x + carrierLogo.frame.size.width + 10.0, 7.0, 75.0, 20.0);
        self.timeLabel.frame = frame;
        
        frame = CGRectMake(timeLabel.frame.origin.x + timeLabel.frame.size.width + 10.0, 7.0, 70.0, 20.0);
        self.priceLabel.frame = frame;
        
        [self.switcher scaleSwitch:CGSizeMake(0.75, 0.75)];
        frame = CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width + 10.0, 7.0, switcher.frame.size.width, switcher.frame.size.height);
        self.switcher.frame = frame;		
        
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        self.carrierLogo = [[self newImage] autorelease];
        [contentView addSubview:carrierLogo];
        //self.carrierLogo =nil;

        self.timeLabel = [[self newLabel] autorelease];
        [contentView addSubview:timeLabel];
        //self.timeLabel = nil;

        self.priceLabel = [[self newLabel] autorelease];
        [contentView addSubview:priceLabel];
        //self.priceLabel = nil;
 
        self.switcher = [[self newSwitcher] autorelease];
        [contentView addSubview:switcher];
        //self.switcher = nil;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    [priceLabel release];
    [timeLabel release];
    [carrierLogo release];
    [switcher release];
    [super dealloc];
}

@end
