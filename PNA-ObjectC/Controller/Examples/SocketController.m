//
//  SocketController.m
//  PNA-ObjectC
//
//  Created by NgocAn Pham on 5/2/18.
//  Copyright © 2018 An. All rights reserved.
//

#import "SocketController.h"
#import <VPSocketIO/VPSocketIO.h>

@interface SocketController (){
    VPSocketIOClient *socket;
}
@end

@implementation SocketController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = @"http://10.183.2.13:3000";
    self->socket = [[VPSocketIOClient alloc] init:[NSURL URLWithString:urlString]
                                       withConfig:@{@"log": @NO}];
    [socket connect];
    [socket on:@"ios position receive" callback:^(NSArray *data, VPSocketAckEmitter *emitter) {
        NSArray *arr = data[0];
        self.moveView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, [arr[0] floatValue] , [arr[1] floatValue], 0);
    }];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveView:)];
    pan.minimumNumberOfTouches = 1;
    [self.moveView addGestureRecognizer:pan];
}
- (void)moveView:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:self.view];
    NSNumber *myNum1 = [NSNumber numberWithInt:point.x];
    NSNumber *myNum2 = [NSNumber numberWithInt:point.y];
    NSArray *arr1 = [NSArray arrayWithObjects: myNum1, myNum2, nil];
    NSArray *arr2 = [NSArray arrayWithObjects: arr1, nil];
    [socket emit:@"ios position send" items:arr2];
}
-(void)closeSocket{
    [socket removeAllHandlers];
    [socket disconnect];
    self->socket = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
