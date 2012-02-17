#import "AddressValidator.h"

@implementation AddressValidator

- (BOOL)validate:(UITextField *)textField
{
    
    __block BOOL answer;
    
    NSArray *numbers = [textField.text componentsSeparatedByString:@"."];
    
    if ([numbers count] != 4)
        answer = NO;
    else
        answer = YES;
    
    [numbers enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop) {
         int number = [(NSString *)obj intValue];
         
         if ((number < 1) || (number > 255))
         {
             answer = NO;
             *stop = YES;
         }
         else
             answer = YES;
     }];
    
    return answer;
}


@end
