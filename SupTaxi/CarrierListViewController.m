#import "CarrierListViewController.h"
#import "Response.h"
#import "CellForDisplayOffers.h"
#import "Offer.h"

@implementation CarrierListViewController

@synthesize resultResponse = resultResponse_;

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
    [resultResponse_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label;
//    if (section == 0) {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
//        label.text = @"Выберите перевозчика";
//        label.textAlignment = UITextAlignmentCenter;
//        
//    } if (section == 1) {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
//        label.text = @"Выберите перевозчика";
//        label.textAlignment = UITextAlignmentCenter;
//        
//    }
//    
//    return label;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 120.0)];
    label.text = @"Выберите перевозчика";
    label.textAlignment = UITextAlignmentCenter;
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, tableView.frame.size.height + 10.0, tableView.frame.size.width, 120.0)];
    label.text = @"Другая инфа";
    label.textAlignment = UITextAlignmentCenter;
    return label;
}

#pragma mark -
#pragma UITableViewDataSourceDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultResponse_.offers count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#warning требуется кастомизация
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CellForDisplayOffers *cell = (CellForDisplayOffers *)[tableView dequeueReusableCellWithIdentifier:@"CellId"];
    UITableViewCell *cell = (CellForDisplayOffers *)[tableView dequeueReusableCellWithIdentifier:@"CellId"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"] autorelease];        
    }
    
    Offer *offer = [resultResponse_.offers objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.text = [NSString stringWithFormat:@"Company: %@    Arrival time: %d         MinPrice: %d", offer.carrierName, offer.arrivalTime, offer.minPrice];
    
    return cell;
}
@end
