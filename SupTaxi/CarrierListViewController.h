//
//  CarrierListViewController.h
//  SupTaxi
//
//  Created by naceka on 19.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Response;

@interface CarrierListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
}

@property (nonatomic, retain) Response *resultResponse;

@end
