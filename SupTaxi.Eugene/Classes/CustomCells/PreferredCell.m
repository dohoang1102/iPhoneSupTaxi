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
@synthesize switcher;

- (UIImageView *)newImage
{
    UIImageView *newImage = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    [newImage setContentMode:UIViewContentModeScaleAspectFit];
    return newImage;
}

- (UICustomSwitch *)newSwitcher
{
	UIColor *color = [UIColor colorWithRed:16.0/255.0 green:79.0/255.0 blue:13.0/255.0 alpha:1];
    UICustomSwitch *newSwitcher = [UICustomSwitch switchWithLeftText:@"I" andRight:@"O"]; 
	[newSwitcher setTintColor: color];
    
    return newSwitcher;
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
        
        [self.switcher scaleSwitch:CGSizeMake(0.75, 0.75)];
        frame = CGRectMake(carrierLogo.frame.origin.x + carrierLogo.frame.size.width + 155.0, 17.0, switcher.frame.size.width, switcher.frame.size.height);
        self.switcher.frame = frame;		
        
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		UIView *contentView = self.contentView;
        
        self.carrierLogo = [self newImage];
        [contentView addSubview:carrierLogo];
        [self.carrierLogo release];

		self.switcher = [self newSwitcher];
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