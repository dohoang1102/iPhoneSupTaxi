//
//  MyClass.m
//  CustomCells
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "SettingsOrderCell.h"
#import "UICustomSwitch.h"

@implementation SettingsOrderCell

@synthesize titleLabel;
@synthesize valueLabel;
@synthesize switcher;

- (UILabel *)newLabel
{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    newLabel.textAlignment = UITextAlignmentLeft;
    newLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    newLabel.backgroundColor = [UIColor whiteColor];
    newLabel.opaque = YES;
    
    return newLabel;
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
        
        frame = CGRectMake(boundsX+5, 5.0, 125.0, 20.0);
        self.titleLabel.frame = frame;
        
        frame = CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width + 10.0, 5.0, 70.0, 20.0);
        self.valueLabel.frame = frame;
        
        [self.switcher scaleSwitch:CGSizeMake(0.75, 0.75)];
        frame = CGRectMake(valueLabel.frame.origin.x + valueLabel.frame.size.width + 10.0, 5.0, switcher.frame.size.width, switcher.frame.size.height);
        self.switcher.frame = frame;		
        
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        
        self.titleLabel = [[self newLabel] autorelease];
        [contentView addSubview:titleLabel];
        //self.titleLabel = nil;
        
        self.valueLabel = [[self newLabel] autorelease];
        [contentView addSubview:valueLabel];
        //self.valueLabel = nil;
        
        self.switcher = [[self newSwitcher] autorelease];
        [contentView addSubview:switcher];
        //[self.switcher release];
        
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
    [titleLabel release];
    [valueLabel release];
    [switcher release];
    [super dealloc];
}

@end
