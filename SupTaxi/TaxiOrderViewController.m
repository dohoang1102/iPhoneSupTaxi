#import "TaxiOrderViewController.h"
#import "CarrierListViewController.h"
#import "Response.h"
#import "ParserClass.h"

@implementation TaxiOrderViewController

#define kSelectButtonIndex 1
#define kCancelButtonIndex 2

@synthesize carTypes = carTypes_;

@synthesize fromPoint = fromPoint_;
@synthesize toPoint = toPoint_;
@synthesize dateTime = dateTime_;
@synthesize carType = carType_;

#pragma mark - Action methods viewController

#define kDatePickerTag 100
#define kDateActionsheet 101
- (IBAction)chooseDateTime:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a date and time" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select", nil];
    [actionSheet showInView:[self.view superview]];
    [actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
    [actionSheet setTag:kDateActionsheet];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 300)];
    [datePicker setMinuteInterval:10];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setTag:kDatePickerTag];
    
    [actionSheet addSubview:datePicker];
    
    [datePicker release];
    
    [actionSheet release];
}

//
#define kCarPickerTag 200
#define kCarTypeActionsheet 201
- (IBAction)chooseCarType:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a car type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select", nil];
    [actionSheet showInView:[self.view superview]];
    [actionSheet setFrame:CGRectMake(0, 117, 320, 383)];
    [actionSheet setTag:kCarTypeActionsheet];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 300)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerView setTag:kCarPickerTag];
    
    [actionSheet addSubview:pickerView];
    
    [pickerView release];
    
    [actionSheet release];
}

#warning TODO
- (IBAction)orderTaxi:(id)sender
{    
    // формируем строку запроса
    NSString *requestString = [NSString stringWithFormat:@"<RequestType=\"Order\" Guid=\"\" From=\"%@\" To=\"%@\" DateTime=\"%@\" VehicleType=\"%@\" />", fromPoint_.text, toPoint_.text, dateTime_, carType_];
    
    NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length:[requestString length]];
    
    // адрес сервера куда отправляется запрос
    NSString *URLString = [NSString stringWithString:@"http://andersensoft.ru/taxi/order.php"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
    [request setHTTPMethod:@"POST"];// метод отправки запроса
    [request setHTTPBody:requestData];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    [request release];
    
    Response *response = [ParserClass loadResponseWithData:responseData];
    
    CarrierListViewController *carrierViewController = [[CarrierListViewController alloc] initWithNibName:@"CarrierListViewController" bundle:nil];
    carrierViewController.resultResponse = response;
    
    [self.navigationController pushViewController:carrierViewController animated:YES];
    [carrierViewController release];
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIPickerViewDelegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@", [[carTypes_ allKeys] objectAtIndex:row]];
}

#pragma mark - UIPickerViewDataSource methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [carTypes_ count];
}

#pragma mark - UIActionSheetDelegate methods

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    NSArray *subviews = [actionSheet subviews];
    
    [[subviews objectAtIndex:kSelectButtonIndex] setFrame:CGRectMake(20, 266, 280, 46)];
    [[subviews objectAtIndex:kCancelButtonIndex] setFrame:CGRectMake(20, 317, 280, 46)];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        if (actionSheet.tag == kDateActionsheet) {
            NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
            
            [dateFomatter setDateFormat:@"dd.MM.YYYY h:mm a"];
            UIDatePicker *picker = (UIDatePicker *)[actionSheet viewWithTag:kDatePickerTag];
            NSDate *selectDate = [picker date];
            dateTime_ = [[NSString alloc] initWithFormat:@"%@", [dateFomatter stringFromDate:selectDate]];
            NSLog(@"%@",dateTime_);
            [dateFomatter release];
        } 
        else if (actionSheet.tag == kCarTypeActionsheet){
            UIPickerView *picker = (UIPickerView *)[actionSheet viewWithTag:kCarPickerTag];
            NSInteger rowIndex = [picker selectedRowInComponent:0];
            NSString *key = [[picker delegate] pickerView:picker titleForRow:rowIndex forComponent:0];
            carType_ = [[NSString alloc] initWithString:[carTypes_ objectForKey:key]];
            NSLog(@"%@",carType_);
        }
    }
}

#pragma mark - life cycle controller methods



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    carTypes_ = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"Эконом",
                                                             @"2", @"Бизнес",
                                                             @"3", @"VIP",
                                                             @"4", @"Грузовой", nil];
    
//    fromPoint_ = [[UITextField alloc] init];
//    toPoint_ = [[UITextField alloc] init];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carTypes = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [carTypes_ release];
    
    [fromPoint_ release];
    [toPoint_ release];
    [dateTime_ release];
    [carType_ release];
    
    [responseStringXML release];
    
    [super dealloc];
}

@end
