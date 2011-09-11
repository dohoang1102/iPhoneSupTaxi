//
//  PreferredViewController.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 09.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferencesManager.h"
#import "Response.h"

@interface PreferredViewController : UITableViewController {
@private
	PreferencesManager * prefManager;
	ResponsePreferred * _preferredResponse;
	Response * _response;
}

@property (nonatomic, retain) ResponsePreferred * _preferredResponse;
@property (nonatomic, retain) Response * _response;

@end
