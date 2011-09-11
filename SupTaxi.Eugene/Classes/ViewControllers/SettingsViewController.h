//
//  SettingsViewController.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 04.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferencesManager.h"
#import "Response.h"

@interface SettingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
	PreferencesManager * prefManager;
    
    Response		* _registerResponse;
	ResponseLogin	* _loginResponse;
}

@property (nonatomic, retain) NSString * supTaxiID;
@property (nonatomic, retain) NSString * userFirstName;
@property (nonatomic, retain) NSString * userSecondName;
@property (nonatomic, retain) NSString * userPassword;
@property (nonatomic, retain) NSString * userPhone;

@property (nonatomic) BOOL userHasContract;
@property (nonatomic) BOOL userHasWish;
@property (nonatomic) BOOL userHasRegularOrder;

@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) Response		* _registerResponse;
@property (nonatomic, retain) ResponseLogin	* _loginResponse;

@end
