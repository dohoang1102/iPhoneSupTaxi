//
//  CarrierListViewController.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Response.h"
#import "PreferencesManager.h"

@interface CarriersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    ResponseOffers *_resultResponse;
	Response	   *_orderResponse;
	PreferencesManager * prefManager;
    NSString * currentOrderId;
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) IBOutlet UIView *innerFooterView;
@property (nonatomic, retain) IBOutlet UIView *innerOfferFooterView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *lblFromTo;

@property (nonatomic, retain) ResponseOffers *_resultResponse;
@property (nonatomic, retain) Response * _orderResponse;

- (void) setResponce:(ResponseOffers*) obj;
- (void) setOrderId:(NSString*) orderId;

@end
