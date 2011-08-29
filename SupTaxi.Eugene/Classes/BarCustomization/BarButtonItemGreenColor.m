
#import "BarButtonItemGreenColor.h"

@implementation UIBarButtonItem (BarButtonItemGreenColor)

+(UIBarButtonItem*)barButtonItemWithTint:(UIColor*)color andTitle:(NSString*)itemTitle andTarget:(id)theTarget andSelector:(SEL)selector
{
    UISegmentedControl *button = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:itemTitle, nil]] autorelease];
    button.momentary = YES;
    button.segmentedControlStyle = UISegmentedControlStyleBar;
    button.tintColor = color;
    [button addTarget:theTarget action:selector forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *removeButton = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    return removeButton;
}

@end
