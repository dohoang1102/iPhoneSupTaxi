//
//  MyAddressViewController.h
//  SupTaxi
//
//  Created by naceka on 21.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupTaxiDataBase.h"
@class EditAddressViewController;

@interface MyAddressViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
}

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
