//
//  QRCodeController.m
//  PNA-ObjectC
//
//  Created by NgocAn Pham on 5/2/18.
//  Copyright © 2018 An. All rights reserved.
//

#import "QRCodeController.h"

@interface QRCodeController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic) BOOL isScanning;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end

@implementation QRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self generalQRCode];
    _isScanning = NO;
    _captureSession = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)generalQRCode{
    NSString *qrString = @"My string to encode";
    NSData *stringData = [qrString dataUsingEncoding: NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrImage = qrFilter.outputImage;
    float scaleX = self.qrcodeImageView.frame.size.width / qrImage.extent.size.width;
    float scaleY = self.qrcodeImageView.frame.size.height / qrImage.extent.size.height;
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    self.qrcodeImageView.image = [UIImage imageWithCIImage:qrImage
                                                 scale:1.0
                                           orientation:UIImageOrientationUp];
}
- (BOOL)startScanning{
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];

    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.qrcodeView.layer.bounds];
    [self.qrcodeView.layer addSublayer:_videoPreviewLayer];
    [_captureSession startRunning];
    return YES;
}
-(void)stopScanning{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            self.statusLabel.text = [metadataObj stringValue];
            [self stopScanning];
            [self.scanButton setTitle:@"Start!" forState:UIControlStateNormal];
            _isScanning = NO;
        }
    }
}
- (IBAction)actionScan:(id)sender{
    if (!_isScanning) {
        if ([self startScanning]) {
            [self.scanButton setTitle:@"Stop" forState:UIControlStateNormal];
            self.statusLabel.text = @"Scanning for QR Code...";
        }
    }
    else{
        [self stopScanning];
        [self.scanButton setTitle:@"Start!" forState:UIControlStateNormal];
    }
    _isScanning = !_isScanning;
}
@end
