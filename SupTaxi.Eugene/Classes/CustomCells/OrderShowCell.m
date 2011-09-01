//
//  MyClass.m
//  CustomCells
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "OrderShowCell.h"

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
    newLabel.backgroundColor = [UIColor whiteColor];
    newLabel.opaque = YES;
    
    return newLabel;
}

- (UIImageView *)newImage
{
    UIImageView *newImage = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    
    return newImage;
}

- (UISwitch *)newSwitcher
{
    UISwitch *newSwitcher = [[UISwitch new] autorelease];
    //newSwitcher.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
    return newSwitcher;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contexctRect = self.contentView.bounds;
    if (!self.editing) {
        CGFloat boundsX = contexctRect.origin.x;
        CGRect frame;
        
        frame = CGRectMake(boundsX, 0, 36.0, 27.0);
        self.carrierLogo.frame = frame;
        
        frame = CGRectMake(carrierLogo.frame.origin.x + carrierLogo.frame.size.width + 10.0, 10.0, 50.0, 20.0);
        self.timeLabel.frame = frame;
        
        frame = CGRectMake(timeLabel.frame.origin.x + timeLabel.frame.size.width + 10.0, 10.0, 50.0, 20.0);
        self.priceLabel.frame = frame;
        
        //self.switcher.transform = CGAffineTransformMakeScale(0.75, 0.75);
        frame = CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width + 10.0, 10.0, switcher.frame.size.width, switcher.frame.size.height);
        self.switcher.frame = frame;
        
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        // логотип
        self.carrierLogo = [self newImage];
        [contentView addSubview:carrierLogo];
        [self.carrierLogo release];
        // время
        self.timeLabel = [self newLabel];
        [contentView addSubview:timeLabel];
        [self.timeLabel release];
        // цена
        self.priceLabel = [self newLabel];
        [contentView addSubview:priceLabel];
        [self.priceLabel release];
        // переключатель
        self.switcher = [self newSwitcher];
        [contentView addSubview:switcher];
        [self.switcher release];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        UIView *contentView = self.contentView;
        
        self.priceLabel = [self newLabel];
        [contentView addSubview:priceLabel];
        [self.priceLabel release];
        
        self.timeLabel = [self newLabel];
        [contentView addSubview:timeLabel];
        [self.timeLabel release];
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
//    [priceLabel release];
//    [timeLabel release];
//    [carrierLogo release];
//    [switcher release];
    [super dealloc];
}

@end
