//
//  AddressViewController.h
//  SupTaxi
//
//  Created by DarkAn on 9/4/11. //Modified my Eugene Zavalko on 06.09.11
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressViewControllerDelegate.h"
#import	"Response.h"
#import "PreferencesManager.h"

enum AddressType { my_addresses, train_stations, airoports }; // 0, 1, 2

@interface AddressViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AddressViewControllerDelegate> {
    ResponseAddress	   *_addressListResponse;
	PreferencesManager * prefManager;
}

//if it is not nil - then this view should call onAddressSelected insted of editing address
@property (nonatomic, assign) id<AddressViewControllerDelegate> selectionDelegate;	

@property (nonatomic, retain) IBOutlet UITableView *addressTable;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) UIBarButtonItem *addAddressButton;
@property (nonatomic, retain) UIBarButtonItem *selectOnMapButton;

@property (nonatomic, assign) enum AddressType addressType;

@property (nonatomic, retain) ResponseAddress * _addressListResponse;

@property (nonatomic, assign) BOOL needReloadData;
@property (nonatomic, assign) BOOL allowsOnMapSelection;

@end
