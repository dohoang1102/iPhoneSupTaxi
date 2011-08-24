//
//  EditAddressViewController.h
//  SupTaxi
//
//  Created by naceka on 21.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyAddress;

@interface EditAddressViewController : UIViewController<UITextFieldDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *addressTextField;
@property (nonatomic, retain) IBOutlet UIButton *addButton;

@property (nonatomic, retain) MyAddress *editingAddress;
@property (nonatomic, assign) BOOL editFlag; 


- (IBAction)addNewAddressAction:(id)sender;

@end
