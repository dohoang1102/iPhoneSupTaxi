//
//  EditAddressViewController.m
//  SupTaxi
//
//  Created by naceka on 21.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditAddressViewController.h"
#import "SupTaxiDataBase.h"
#import "MyAddress.h"

@implementation EditAddressViewController

@synthesize nameTextField = nameTextField_;
@synthesize addressTextField = addressTextField_;
@synthesize addButton = addButton_;

@synthesize editingAddress = editingAddress_;
@synthesize editFlag = editFlag_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [nameTextField_ release];
    [addressTextField_ release];
    [editingAddress_ release];
    [addButton_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)addNewAddress:(NSString *)address name:(NSString *)name
{
    NSManagedObjectContext *context = [[SupTaxiDataBase sharedInstance] managedObjectContext];
    MyAddress *myAddress = [NSEntityDescription insertNewObjectForEntityForName:@"MyAddress" inManagedObjectContext:context];
    myAddress.name = name;
    myAddress.address = address;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addNewAddressAction:(id)sender
{
    [self addNewAddress:[addressTextField_ text] name:[nameTextField_ text]];
}

- (void)saveObject
{
    [editingAddress_ setName:[nameTextField_ text]];
    [editingAddress_ setAddress:[addressTextField_ text]];
    NSError *error;
    if (![[[SupTaxiDataBase sharedInstance] managedObjectContext] save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    addressTextField_.delegate = self;
    nameTextField_.delegate = self;
    
    if (editFlag_) {
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Сохранить"  style:UIBarButtonItemStyleDone target:self action:@selector(saveObject)];
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];
        
        addButton_.hidden = YES;
        nameTextField_.text = editingAddress_.name;
        addressTextField_.text = editingAddress_.address;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
