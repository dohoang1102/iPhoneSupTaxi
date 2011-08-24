//
//  FirstViewController.h
//  SupTaxi
//
//  Created by naceka on 15.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kEconomicalCarType 1;
#define kBusinessCarType 2;
#define kViplCarType 3;
#define kCargoCarType 4;

@interface TaxiOrderViewController : UIViewController<UIActionSheetDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    NSString *responseStringXML;
}

@property (nonatomic, retain) NSDictionary *carTypes;

//@property (nonatomic, copy) NSString *fromPoint;
//@property (nonatomic, copy) NSString *toPoint;
@property (nonatomic, retain) IBOutlet UITextField *fromPoint;
@property (nonatomic, retain) IBOutlet UITextField *toPoint;
@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *carType;

- (IBAction)chooseDateTime:(id)sender;
- (IBAction)chooseCarType:(id)sender;
- (IBAction)orderTaxi:(id)sender;

@end
