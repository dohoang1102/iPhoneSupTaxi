//
//  ContractViewController.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 04.09.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferencesManager.h"
#import "Response.h"

@interface ContractViewController : UIViewController <UITextFieldDelegate>{
	PreferencesManager * prefManager;
    Response		* _updateResponse;
}

@property (nonatomic, retain) IBOutlet UITextField *txtContractNumber;
@property (nonatomic, retain) IBOutlet UITextField *txtContractCustomer;
@property (nonatomic, retain) IBOutlet UITextField *txtContractCarrier;

@property (nonatomic, retain) Response * _updateResponse;

@property (nonatomic, assign) SEL selectorOnDone;
@property (nonatomic, assign) id delegate;

@end
