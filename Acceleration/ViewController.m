#import "ViewController.h"

@interface ViewController()

@property (nonatomic,strong) DataSender *sender;
@property (nonatomic,assign) BOOL sending;

- (void)goBackToNonSendingState;

@end

@implementation ViewController

@synthesize xIndicator;
@synthesize yIndicator;
@synthesize zIndicator;

@synthesize xLabel;
@synthesize yLabel;
@synthesize zLabel;

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

#define MAX_ACCELL 2.1

- (void)accelerometer:(UIAccelerometer *)accelerometer 
        didAccelerate:(UIAcceleration *)acceleration 
{
    
    self.xLabel.text = [NSString stringWithFormat:@"a.x = %g",acceleration.x];
    self.yLabel.text = [NSString stringWithFormat:@"a.y = %g",acceleration.y];
    self.zLabel.text = [NSString stringWithFormat:@"a.z = %g",acceleration.z];
    
    self.xIndicator.progress = 0.5f + (float)(acceleration.x/MAX_ACCELL);
    self.yIndicator.progress = 0.5f + (float)(acceleration.y/MAX_ACCELL);
    self.zIndicator.progress = 0.5f + (float)(acceleration.z/MAX_ACCELL);

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
    [super awakeFromNib];
    
    self.sending = NO;
    
    self.sender = [[DataSender alloc] init];
}

- (void)viewDidUnload
{
    
    self.senderButton = nil;
    
    [self setXLabel:nil];
    [self setYLabel:nil];
    [self setZLabel:nil];
    [self setXIndicator:nil];
    [self setYIndicator:nil];
    [self setZIndicator:nil];
    
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
