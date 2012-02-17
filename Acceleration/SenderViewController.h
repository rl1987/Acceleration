#import <UIKit/UIKit.h>

#import "ValidatingTextField.h"

@class SenderViewController;

@protocol SenderViewControllerDelegate
@required
- (void)senderViewController:(SenderViewController *)svc 
        didFinishWithAddress:(NSString *)ipAddressString
                     andPort:(int)port;

@end

@interface SenderViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet ValidatingTextField *addressField;
@property (strong, nonatomic) IBOutlet ValidatingTextField *portField;
@property (nonatomic, strong) id <SenderViewControllerDelegate> delegate;

- (IBAction)okPressed;
- (IBAction)cancelPressed;

@end

