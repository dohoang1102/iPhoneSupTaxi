#import "CarrierListViewController.h"
#import "Response.h"
#import "Offer.h"
#import <QuartzCore/QuartzCore.h>
#import "OrderShowCell.h"

@implementation CarrierListViewController

@synthesize headerView = headerView_;
@synthesize footerView = footerView_;
@synthesize innerFooterView = innerFooterView_;

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
    [headerView_ release];
    [footerView_ release];
    [innerFooterView_ release];
    
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
    // делаем прозрачный фон
    headerView_.backgroundColor = [UIColor clearColor];
    
    // скругляем углы
    innerFooterView_.layer.cornerRadius = 10;
    
    // кнопка заказать
    UIBarButtonItem *orderButton = [[UIBarButtonItem alloc] initWithTitle:@"Заказать" style:UIBarButtonItemStylePlain target:self action:@selector(orderAction)];
    self.navigationItem.rightBarButtonItem = orderButton;
    [orderButton release];
    
    // цвет navigation bar
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1];
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
// высота каждой ячейки
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// высота шапки
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
	return 50.0;
}

// высота нижней части
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section 
{
	return 120.0;
}

// шапка таблицы
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{    
    return headerView_;
}

// нижняя часть таблицы
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section 
{    
    return footerView_;
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

// 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CellForDisplayOffers *cell = (CellForDisplayOffers *)[tableView dequeueReusableCellWithIdentifier:@"CellId"];
    OrderShowCell *cell = (OrderShowCell *)[tableView dequeueReusableCellWithIdentifier:@"CellId"];
    if (cell == nil) {
        cell = [[[OrderShowCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"CellId"] autorelease];        
    }
    
    Offer *offer = [resultResponse_.offers objectAtIndex:indexPath.row];
    
    cell.carrierLogo.image = nil;
    cell.timeLabel.text = [NSString stringWithFormat:@"~ %d минут", offer.arrivalTime]; 
    cell.priceLabel.text = [NSString stringWithFormat:@"%d руб**", offer.minPrice]; 
    
    return cell;
}
@end
