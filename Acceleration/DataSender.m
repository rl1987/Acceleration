#import "DataSender.h"

static DataSender *_defaultSender;

@interface DataSender() <NSStreamDelegate>

@property (nonatomic,strong) NSOutputStream *outStream;
@property (nonatomic,assign) BOOL ready;

@end

@implementation DataSender

@synthesize destinationIP = _destinationIP;
@synthesize destinationPort = _destinationPort;

@synthesize outStream = _outStream;
@synthesize ready = _ready;

- (void)setDestinationIP:(NSString *)destinationIP
{
    if ([_destinationIP isEqualToString:destinationIP])
        return;
    
    [self.outStream close];
    
    CFWriteStreamRef outStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, 
                                       (__bridge CFStringRef)destinationIP, 
                                       self.destinationPort, NULL, &outStream);
    
    
    self.outStream = (__bridge NSOutputStream *)outStream;

    _destinationIP = destinationIP;
    
    [self.outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] 
                              forMode:NSDefaultRunLoopMode];
    
    self.outStream.delegate = self;
    
    self.ready = YES;
    
}

- (void)setDestinationPort:(int)destinationPort
{
    if (_destinationPort == destinationPort)
        return;
    
    [self.outStream close];
    
    CFWriteStreamRef outStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, 
                                       (__bridge CFStringRef)self.destinationIP, 
                                       destinationPort, NULL, &outStream);
    
    self.outStream = (__bridge NSOutputStream *)outStream;
    
    _destinationPort = destinationPort;
    
    [self.outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] 
                              forMode:NSDefaultRunLoopMode];
    
    self.outStream.delegate = self;
    
    self.ready = YES;
    
}

+ (DataSender *)defaultSender
{
    if (!_defaultSender)
        _defaultSender = [[DataSender alloc] init];
    
    return _defaultSender;
}

- (id)init
{
    self = [super init];
    
    if (self)
        self.ready = NO;        
    
    return self;
}

- (void)sendString:(NSString *)str
{
    if (self.ready)
        [self sendData:[str dataUsingEncoding:NSASCIIStringEncoding]];
}

- (void)sendData:(NSData *)data
{
    if (self.ready)
    {
        [self.outStream open];
        
        [self.outStream write:[data bytes] maxLength:[data length]];
    }
}

- (BOOL)isReady
{
    return _ready;
}

#pragma mark -
#pragma mark NSStream delegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    
    NSLog(@"DataSender stream: handleEvent:");
    NSLog(@"%d",eventCode);
    
    if (eventCode == NSStreamEventErrorOccurred)
    {
        self.destinationIP = nil;
        self.destinationPort = nil;
        self.outStream = nil;
        self.ready = NO;
    }
}


@end
