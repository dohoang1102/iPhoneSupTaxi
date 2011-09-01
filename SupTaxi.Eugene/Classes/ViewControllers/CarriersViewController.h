//
//  CarrierListViewController.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 01.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ResponseOffers;

@interface CarriersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    ResponseOffers *_resultResponse;
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) IBOutlet UIView *innerFooterView;

@property (nonatomic, retain) ResponseOffers *_resultResponse;

@end
