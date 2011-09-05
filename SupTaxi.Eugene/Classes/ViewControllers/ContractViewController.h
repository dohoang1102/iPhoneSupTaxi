//
//  ContractViewController.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 04.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferencesManager.h"

@interface ContractViewController : UIViewController <UITextFieldDelegate>{
	PreferencesManager * prefManager;
}

@property (nonatomic, retain) IBOutlet UITextField *txtContractNumber;
@property (nonatomic, retain) IBOutlet UITextField *txtContractCustomer;
@property (nonatomic, retain) IBOutlet UITextField *txtContractCarrier;

- (IBAction) contractSave:(id)sender;
- (IBAction) contractDecline:(id)sender;

@end
