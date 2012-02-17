#import "ViewController.h"

@interface ViewController()

@property (nonatomic,strong) DataSender *sender;
@property (nonatomic,assign) BOOL sending;

- (void)goBackToNonSendingState;

@end

@implementation ViewController

@synthesize readoutLabel;
@synthesize senderButton;

@synthesize sender = _sender;
@synthesize sending = _sending;

- (void)goBackToNonSendingState
{
    UIAlertView *alert = 
    [[UIAlertView alloc] initWithTitle:@"ERROR" 
                               message:@"Network connection failed." 
                              delegate:nil 
                     cancelButtonTitle:@"OK" 
                     otherButtonTitles:nil];
        
    [alert show];
    
    self.sending = NO;
    self.senderButton.titleLabel.text = @"Transmit";
}

#pragma mark -
#pragma mark Sender view controller delegate

- (void)senderViewController:(SenderViewController *)svc 
        didFinishWithAddress:(NSString *)ipAddressString
                     andPort:(int)port
{
    NSLog(@"ViewController senderViewController:didFinishWithAddress:andPort:");
    NSLog(@"%@ %d",ipAddressString,port);
        
    self.sender.destinationIP = ipAddressString;
    self.sender.destinationPort = port;
    
    if ([self.sender isReady])
    {
        self.sending = YES;
        self.senderButton.titleLabel.text = @"Stop";
    }
    else
        [self goBackToNonSendingState];

}

#pragma mark -
#pragma mark Accelerometer delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer 
        didAccelerate:(UIAcceleration *)acceleration 
{
    self.readoutLabel.text = [NSString stringWithFormat:@"%g, %g, %g",
                              acceleration.x,acceleration.y,acceleration.z];
    
    if (self.sending == YES)
    {
        if ([self.sender isReady])
            [self.sender sendString:[NSString stringWithFormat:@"%g %g %g\n",
                                     acceleration.x,acceleration.y,
                                     acceleration.z]];
        else
            [self goBackToNonSendingState];
    }
}

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    self.sending = NO;
    
    self.sender = [[DataSender alloc] init];
}

- (void)viewDidUnload
{
    [self setReadoutLabel:nil];
    
    self.senderButton = nil;
    
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
#pragma mark Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [(SenderViewController *)segue.destinationViewController setDelegate:self];
}

#pragma mark -
#pragma mark Target-action stuff

- (IBAction)buttonPressed:(UIButton *)sender 
{
    if (self.sending)
    {
        self.sending = NO;
        sender.titleLabel.text = @"Transmit";
    }
    else
    {
        [self performSegueWithIdentifier:@"SegueToCommSenderVC" sender:self];
    }
}

@end
