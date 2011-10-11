//
//  HstoryItemCell.m
//  SupTaxi
//
//  Created by Eugene Zavalko on 07.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import "HistoryItemCell.h"


@implementation HistoryItemCell

@synthesize lblFromTo;
@synthesize lblDate;
@synthesize lblStatus;

- (UILabel *)newFromToLabel
{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    newLabel.textAlignment = UITextAlignmentLeft;
	newLabel.numberOfLines = 2;
	[newLabel setLineBreakMode:UILineBreakModeWordWrap];
    newLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    newLabel.backgroundColor = [UIColor whiteColor];
    newLabel.opaque = YES;
    
    return newLabel;
}

- (UILabel *)newDateStatusLabel:(UITextAlignment) align
{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    newLabel.textAlignment = align;
    newLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    newLabel.backgroundColor = [UIColor whiteColor];
    newLabel.opaque = YES;
    
    return newLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contexctRect = self.contentView.bounds;
    if (!self.editing) {
        CGFloat boundsX = contexctRect.origin.x;
		CGFloat boundsW = contexctRect.size.width;
        CGRect frame;
        
        frame = CGRectMake(boundsX+5, 5.0, boundsW-10, 40.0);
        self.lblFromTo.frame = frame;
		
        frame = CGRectMake(boundsX+5, 50, boundsW/2-30, 15.0);
        self.lblDate.frame = frame;
        
        frame = CGRectMake(boundsW/2-35, 50, boundsW/2+30, 15.0);
        self.lblStatus.frame = frame;       
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;

        self.lblFromTo = [[self newFromToLabel] autorelease];
        [contentView addSubview:lblFromTo];
        //self.lblFromTo = nil;

		self.lblDate = [[self newDateStatusLabel:UITextAlignmentLeft] autorelease];
        [contentView addSubview:lblDate];
        //self.lblDate = nil;
		
        self.lblStatus = [[self newDateStatusLabel:UITextAlignmentRight] autorelease];
        [contentView addSubview:lblStatus];
        //self.lblStatus = nil; 
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    [lblDate release];
    [lblFromTo release];
    [lblStatus release];
    [super dealloc];
}

@end
