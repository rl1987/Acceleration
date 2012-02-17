#import "ViewController.h"

@interface ViewController()

@property (nonatomic,strong) DataSender *sender;
@property (nonatomic,assign) BOOL sending;

@end

@implementation ViewController

@synthesize readoutLabel;
@synthesize senderButton;

@synthesize sender = _sender;
@synthesize sending = _sending;

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
    
    self.sending = YES;
    
    if ([self.sender isReady])
    {
        self.senderButton.titleLabel.text = @"Stop";
    }
}

#pragma mark -
#pragma mark Accelerometer delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer 
        didAccelerate:(UIAcceleration *)acceleration 
{
    self.readoutLabel.text = [NSString stringWithFormat:@"%g, %g, %g",
                              acceleration.x,acceleration.y,acceleration.z];
    
    if ((self.sending == YES) && [self.sender isReady])
        [self.sender sendString:
         [NSString stringWithFormat:@"%g %g %g\n",
          acceleration.x,acceleration.y,acceleration.z]];
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
