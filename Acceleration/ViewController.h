#import <UIKit/UIKit.h>

#import "DataSender.h"
#import "SenderViewController.h"

@interface ViewController : UIViewController 
<UIAccelerometerDelegate, SenderViewControllerDelegate>

@property (nonatomic,strong) IBOutlet UIButton *senderButton;

@property (strong, nonatomic) IBOutlet UILabel *xLabel;
@property (strong, nonatomic) IBOutlet UILabel *yLabel;
@property (strong, nonatomic) IBOutlet UILabel *zLabel;

@property (strong, nonatomic) IBOutlet UIProgressView *xIndicator;
@property (strong, nonatomic) IBOutlet UIProgressView *yIndicator;
@property (strong, nonatomic) IBOutlet UIProgressView *zIndicator;

- (IBAction)buttonPressed:(UIButton *)sender;

@end
