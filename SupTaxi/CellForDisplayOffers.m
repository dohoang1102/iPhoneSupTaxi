//
//  CellForDisplayOffers.m
//  SupTaxi
//
//  Created by naceka on 20.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CellForDisplayOffers.h"


@implementation CellForDisplayOffers

@synthesize timeLabel = timeLabel_;
@synthesize priceLabel = priceLabel_;
@synthesize companyLogoImage = companyLogoImage_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        timeLabel_ = [[UILabel alloc] init];
        timeLabel_.textAlignment = UITextAlignmentLeft;
        
        priceLabel_ = [[UILabel alloc] init];
        priceLabel_.textAlignment = UITextAlignmentLeft;
        
        companyLogoImage_ = [[UIImageView alloc] init];
        
        [self.contentView addSubview:timeLabel_];
        [self.contentView addSubview:priceLabel_];
        [self.contentView addSubview:companyLogoImage_];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    
#warning изменить в соответствии с размером логотипа
    frame = CGRectMake(boundsX + 10, 0, 50, 50);
    companyLogoImage_.frame = frame;
    
    frame = CGRectMake(boundsX + 70, 10, 100, 25);
    priceLabel_.frame = frame;
    
    frame = CGRectMake(boundsX + 190, 10, 100, 25);
    timeLabel_.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [timeLabel_ release];
    [priceLabel_ release];
    [super dealloc];
}

@end
