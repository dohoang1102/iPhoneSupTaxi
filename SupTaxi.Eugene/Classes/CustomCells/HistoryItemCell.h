//
//  HstoryItemCell.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 07.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HistoryItemCell : UITableViewCell

@property (nonatomic, retain) UILabel *lblFromTo;
@property (nonatomic, retain) UILabel *lblDate;
@property (nonatomic, retain) UILabel *lblStatus;

@end
