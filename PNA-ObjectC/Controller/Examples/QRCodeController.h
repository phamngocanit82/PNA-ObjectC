//
//  QRCodeController.h
//  PNA-ObjectC
//
//  Created by NgocAn Pham on 5/2/18.
//  Copyright © 2018 An. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;
@property (weak, nonatomic) IBOutlet UIView *qrcodeView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet CustomButton *scanButton;
@end
