//
//  PreferredCell.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 09.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "PreferredCell.h"


@implementation PreferredCell

@synthesize carrierLogo;
@synthesize lblCarrierName;
@synthesize switcher;

- (UILabel *)newLabel
{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    newLabel.textAlignment = UITextAlignmentLeft;
    newLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    newLabel.backgroundColor = [UIColor clearColor];
    newLabel.opaque = YES;
    
    return newLabel;
}

- (UIImageView *)newImage
{
    UIImageView *newImage = [[UIImageView alloc] initWithFrame:CGRectZero];
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
        
        frame = CGRectMake(boundsX+5, 7.0, 60.0, 35.0);
        self.carrierLogo.frame = frame;
        
        frame = CGRectMake(carrierLogo.frame.origin.x + carrierLogo.frame.size.width + 10.0, 7.0, 145.0, 35.0);
        self.lblCarrierName.frame = frame;
        
        [self.switcher scaleSwitch:CGSizeMake(0.75, 0.75)];
        frame = CGRectMake(lblCarrierName.frame.origin.x + lblCarrierName.frame.size.width + 10.0, 17.0, switcher.frame.size.width, switcher.frame.size.height);
        self.switcher.frame = frame;		
        
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		UIView *contentView = self.contentView;
        UIImageView * img = [self newImage];
        self.carrierLogo = img;
        [img release];
        [contentView addSubview:carrierLogo];
        //self.carrierLogo = nil;

        UILabel * lbl = [self newLabel];
        self.lblCarrierName = lbl;
        [lbl release];
        [contentView addSubview:lblCarrierName];
        //self.lblCarrierName = nil;
        
        UICustomSwitch * sw = [self newSwitcher];
		self.switcher = sw;
        [sw release];
        [contentView addSubview:switcher];
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[switcher release];
    [super dealloc];
}


@end
