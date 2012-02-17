#import "ViewController.h"

@implementation ViewController
@synthesize readoutLabel;

#pragma mark -
#pragma mark Sender view controller delegate

- (void)senderViewController:(SenderViewController *)svc 
        didFinishWithAddress:(NSString *)ipAddressString
                     andPort:(int)port
{
    NSLog(@"ViewController senderViewController:didFinishWithAddress:andPort:");
    NSLog(@"%@ %d",ipAddressString,port);
}

#pragma mark -
#pragma mark Accelerometer delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer 
        didAccelerate:(UIAcceleration *)acceleration 
{
    self.readoutLabel.text = [NSString stringWithFormat:@"%g, %g, %g",
                              acceleration.x,acceleration.y,acceleration.z];
    
//    if ([[DataSender defaultSender] isReady])
//        [[DataSender defaultSender] sendString:
//         [NSString stringWithFormat:@"%g %g %g",
//          acceleration.x,acceleration.y,acceleration.z]];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [self setReadoutLabel:nil];
    
    [super viewDidUnload];
}

#define PERIOD 0.1

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:PERIOD];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [(SenderViewController *)segue.destinationViewController setDelegate:self];
}

@end
