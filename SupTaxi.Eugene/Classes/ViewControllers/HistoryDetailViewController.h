//
//  HistoryDetailViewController.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 07.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "Address.h"

@interface HistoryDetailViewController : UIViewController {

	Order * orderToView;
	
}

@property (nonatomic, retain) IBOutlet UILabel * lblTime;
@property (nonatomic, retain) IBOutlet UILabel * lblFrom;
@property (nonatomic, retain) IBOutlet UILabel * lblTo;
@property (nonatomic, retain) IBOutlet UILabel * lblStatus;
@property (nonatomic, retain) IBOutlet UILabel * lblComment;
@property (nonatomic, retain) IBOutlet UILabel * lblCarrier;

@property (nonatomic, retain) IBOutlet UILabel * lblSchedule;
@property (nonatomic, retain) IBOutlet UILabel * lblCType;

- (void) SetOrder:(Order*)order;

- (IBAction)btnAddFrom:(id)sender;
- (IBAction)btnAddTo:(id)sender;
- (Address*) getAddress:(NSString*)address area:(NSString*)area lat:(double)lat lon:(double)lon;

@end
