//
//  MyClass.m
//  CustomCells
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsCell

@synthesize titleLabel;
@synthesize textField;

- (UILabel *)newLabel
{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    newLabel.textAlignment = UITextAlignmentLeft;
    newLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    newLabel.backgroundColor = [UIColor whiteColor];
    newLabel.opaque = YES;
    
    return newLabel;
}

- (UITextField *)newTextField
{
	UITextField *newTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    newTextField.font = [UIFont fontWithName:@"Helvetica" size:14.0];
	[newTextField setBorderStyle:UITextBorderStyleNone];
    return newTextField;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contexctRect = self.contentView.bounds;
    if (!self.editing) {
        CGFloat boundsX = contexctRect.origin.x;
        CGRect frame;
        
        frame = CGRectMake(boundsX+5, 5.0, 70.0, 20.0);
        self.titleLabel.frame = frame;
        
        frame = CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width + 10.0, 5.0, 200.0, 20.0);
        self.textField.frame = frame;
   
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        
        self.titleLabel = [self newLabel];
        [contentView addSubview:titleLabel];
        [self.titleLabel release];
        
        self.textField = [self newTextField];
        [contentView addSubview:textField];
        //[self.textField release];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        UIView *contentView = self.contentView;
        
        self.titleLabel = [self newLabel];
        [contentView addSubview:titleLabel];
        [self.titleLabel release];
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
    [super dealloc];
}

@end
