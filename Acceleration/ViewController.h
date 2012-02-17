#import <UIKit/UIKit.h>

#import "DataSender.h"
#import "SenderViewController.h"

@interface ViewController : UIViewController 
<UIAccelerometerDelegate, SenderViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *readoutLabel;

@end
