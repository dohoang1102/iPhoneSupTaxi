//
//  MapViewRouteSearchBar.h
//  SupTaxi
//
//  Created by DarkAn on 9/4/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewBaseBar.h"
#import "AddressViewControllerDelegate.h"
#import "PreferencesManager.h"

@interface MapViewRouteSearchBar : MapViewBaseBar <UITextFieldDelegate, AddressViewControllerDelegate> {
    BOOL hidden;
	
	PreferencesManager *prefManager;
	
	GoogleResultPlacemark *placeMarkFrom; 
	GoogleResultPlacemark *placeMarkTo;
}


@property (nonatomic, retain) IBOutlet UITextField *fromField;
@property (nonatomic, retain) IBOutlet UITextField *toField;
@property (nonatomic, retain) IBOutlet UIButton *fromAddressButton;

@property (nonatomic, retain) IBOutlet UITextField *timeField;

@property (nonatomic, retain) IBOutlet UIView *daysView;
@property (nonatomic, retain) IBOutlet UITextField *daysField;

@property (nonatomic, retain) IBOutlet UIView *carView;
@property (nonatomic, retain) IBOutlet UIImageView *carImageView;
@property (nonatomic, retain) IBOutlet UILabel *carTypeLabel;

@property (nonatomic, retain) GoogleResultPlacemark *placeMarkFrom;
@property (nonatomic, retain) GoogleResultPlacemark *placeMarkTo;
@property (nonatomic, retain) GoogleResultPlacemark *selfLocationPlacemark;


@property (nonatomic, retain) id parentController;

@property (nonatomic, retain) NSString *currentFieldName;
@property (nonatomic, retain) UITextField *currentTextField;

@property (nonatomic, assign) BOOL daysVisible;

-(IBAction)onGetFromAddressBook:(id)sender;
-(IBAction)onReverseDirection:(id)sender;
-(IBAction)onChangeCar:(id)sender;
-(IBAction)onChangeDate:(id)sender;

- (BOOL) checkIfAuthenticated;
- (void) loadAddressList:(id)sender;
- (void) showAlertMessage:(NSString *)alertMessage;
- (void) AddressResult:(id)obj;
- (void) ShowConnectionAlert:(id)obj;
- (void) GetNearestThreadMethod:(id)obj;

@end
