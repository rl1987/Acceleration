#import <Foundation/Foundation.h>

@interface DataSender : NSObject

@property (nonatomic, strong) NSString *destinationIP;
@property (nonatomic, assign) int destinationPort;

+ (DataSender *)defaultSender;

- (void)sendString:(NSString *)str;
- (void)sendData:(NSData *)data;

- (BOOL)isReady;

@end
