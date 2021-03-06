//
//  RegisterViewController.h
//  SupTaxi
//
//  Created by Eugene Zavalko on 30.08.11.
//  Copyright 2011 EaZySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Response.h"
#import "PreferencesManager.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate> {
@private
	Response		* _registerResponse;
	ResponseLogin	* _loginResponse;
	
	PreferencesManager * prefManager;
}

@property (nonatomic, retain) IBOutlet UITextField *txtEmail;
@property (nonatomic, retain) IBOutlet UITextField *txtPassword;
@property (nonatomic, retain) IBOutlet UITextField *txtLastName;
@property (nonatomic, retain) IBOutlet UITextField *txtName;
@property (nonatomic, retain) IBOutlet UITextField *txtPhone;

@property (nonatomic, retain) IBOutlet UIButton *btnAccept;

@property (nonatomic, assign) SEL selectorOnDone;
@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) Response		* _registerResponse;
@property (nonatomic, retain) ResponseLogin	* _loginResponse;


- (IBAction) selectCheckBox:(id)sender;
- (IBAction) registerAction:(id)sender;
- (IBAction) registerActionDecline:(id)sender;


@end
