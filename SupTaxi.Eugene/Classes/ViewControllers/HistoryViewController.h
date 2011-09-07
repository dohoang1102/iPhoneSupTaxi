//
//  HistoryViewController.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 04.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferencesManager.h"
#import "Response.h"

@class HistoryDetailViewController;

@interface HistoryViewController : UITableViewController {
@private
	NSMutableArray * _hItems;
	NSUInteger _pagesLoadedCount;
	NSUInteger _totalPagesCount;
	NSUInteger _totalItemsCount;
	
	ResponseHistory * _historyResponse;
	PreferencesManager * prefManager;
	
	HistoryDetailViewController * detailView;
}

@property (nonatomic, retain) ResponseHistory * _historyResponse;

@end
