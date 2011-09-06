//
//  MapViewAddressSearchBar.h
//  SupTaxi
//
//  Created by DarkAn on 9/4/11.
//  Copyright 2011 DNK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewBaseBar.h"

@interface MapViewAddressSearchBar : MapViewBaseBar <UITextFieldDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *addressField;

@property (nonatomic, retain) GoogleResultPlacemark *placeMark;

-(BOOL)validate; //checks if all the fields filled

@end
