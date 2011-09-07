//
//  HistoryDetailViewController.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 07.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface HistoryDetailViewController : UIViewController {

	Order * orderToView;
	
}

@property (nonatomic, retain) IBOutlet UILabel * lblTime;
@property (nonatomic, retain) IBOutlet UILabel * lblFrom;
@property (nonatomic, retain) IBOutlet UILabel * lblTo;
@property (nonatomic, retain) IBOutlet UILabel * lblStatus;
@property (nonatomic, retain) IBOutlet UILabel * lblComment;

- (void) SetOrder:(Order*)order;

@end
