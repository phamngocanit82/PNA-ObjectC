#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#define DELAY_GET_DEVICES 5
enum BAND_DATA{
    BAND_DATA_CANCEL,
    BAND_DATA_POWERED,
    BAND_DATA_GET_DEVICES,
    STATE_POWERED_ON,
    STATE_POWERED_OFF,
};
@interface BluetoothService : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (copy, nonatomic) void (^ callbackComplete)(NSMutableDictionary *response);
@property (copy, nonatomic) void (^ callbackError)(void);
@property (assign) NSInteger intStatus;
@property (assign) NSInteger intStatePowered;
@property (strong, nonatomic) CBCentralManager *cbCentralManager;
@property (strong, nonatomic) NSMutableDictionary *response;
@property (strong, nonatomic) NSMutableArray *deviceArray;
+(id)sharedInstance;
-(void)cancel;
-(void)getStatePowered:(void(^) (NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
-(void)getDevices:(void(^) (NSMutableDictionary* response))callComplete withError:(void(^)(void))callError;
@end
