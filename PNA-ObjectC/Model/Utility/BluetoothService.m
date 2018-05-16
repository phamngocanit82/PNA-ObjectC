#import "BluetoothService.h"
@interface BluetoothService ()

@end
@implementation BluetoothService
+(instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance initBluetooth];
    });
    return sharedInstance;
}
-(void)initBluetooth{
    self.intStatePowered = STATE_POWERED_OFF;
    self.response = [[NSMutableDictionary alloc] init];
    self.deviceArray = [[NSMutableArray alloc] initWithCapacity:0];
}
-(CBCentralManager*)getCBCentralManager{
    if (!self.cbCentralManager) {
        if(SYSTEM_VERSION_LESS_THAN(@"11.1")){
            self.cbCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey: @(YES)}];
        }else{
            self.cbCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey: @(YES)}];
        }
    }
    return self.cbCentralManager;
}
-(void)cancel{
    self.intStatus = BAND_DATA_CANCEL;
    self.callbackComplete = nil;
    self.callbackError = nil;
}
-(void)getStatePowered:(void(^) (NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    self.intStatus = BAND_DATA_POWERED;
    self.callbackComplete = callComplete;
    self.callbackError = callError;
    if (self.cbCentralManager){
        if ([self.cbCentralManager state] == CBCentralManagerStatePoweredOn) {
            self.intStatePowered = STATE_POWERED_ON;
        }else if ([self.cbCentralManager state] == CBCentralManagerStatePoweredOff){
            self.intStatePowered = STATE_POWERED_OFF;
        }
        self.callbackComplete(nil);
    }
    [self getCBCentralManager];
}
-(void)getDevices:(void(^) (NSMutableDictionary* response))callComplete withError:(void(^)(void))callError{
    self.intStatus = BAND_DATA_GET_DEVICES;
    self.callbackComplete = callComplete;
    self.callbackError = callError;
    [self.deviceArray removeAllObjects];
    [self.response setObject:self.deviceArray forKey:@"devices"];
    self.callbackComplete(self.response);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayGetDevices) object:nil];
    [self performSelector:@selector(delayGetDevices) withObject:nil afterDelay:5];
    if([self getCBCentralManager]){
        [self.cbCentralManager scanForPeripheralsWithServices:nil options:nil];
    }
}
-(void)delayGetDevices{
    if(self.intStatus == BAND_DATA_GET_DEVICES){
        if(self.cbCentralManager){
            [self.cbCentralManager stopScan];
        }
        [self.response setObject:self.deviceArray forKey:@"devices"];
        if(self.callbackComplete){
            self.callbackComplete(self.response);
        }
    }
}
-(BOOL)checkUDID:(NSUUID*)identifier{
    for (int i=0; i<[self.deviceArray count]; i++) {
        CBPeripheral *peripheral = [self.deviceArray objectAtIndex:i][@"peripheral"];
        if ([peripheral.identifier isEqual:identifier])
            return  TRUE;
    }
    return  FALSE;
}
//CBCentralManager
-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if ([central state] == CBCentralManagerStatePoweredOn) {
        self.intStatePowered = STATE_POWERED_ON;
    }else if ([central state] == CBCentralManagerStatePoweredOff){
        self.intStatePowered = STATE_POWERED_OFF;
        self.cbCentralManager = nil;
    }
    if(self.intStatus == BAND_DATA_POWERED){
        self.callbackComplete(nil);
    }
}
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if(self.intStatus == BAND_DATA_GET_DEVICES){
        if(self.cbCentralManager){
            NSDictionary *result = @{@"peripheral": peripheral, @"advertisementData": advertisementData, @"RSSI": RSSI};
            NSArray * allKeys = [advertisementData allKeys];
            if([allKeys containsObject:@"kCBAdvDataLocalName"]){
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                for (NSString* key in result){
                    [dic setValue:[result valueForKey:key] forKey:key];
                }
                if (![self.deviceArray containsObject:result]) {
                    if (![self checkUDID:peripheral.identifier])
                        [self.deviceArray addObject:dic];
                }else{
                    for (int i=0; i<[self.deviceArray count]; i++) {
                        CBPeripheral *per = [self.deviceArray objectAtIndex:i][@"peripheral"];
                        if ([per.identifier isEqual:peripheral.identifier]){
                            [self.deviceArray replaceObjectAtIndex:i withObject:dic];
                            break;
                        }
                    }
                }
            }
        }else{
            [self.deviceArray removeAllObjects];
        }
        [self.response setObject:self.deviceArray forKey:@"devices"];
        self.callbackComplete(self.response);
    }
}
@end
