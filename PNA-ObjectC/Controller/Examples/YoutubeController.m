//
//  YoutubeController.m
//  PNA-ObjectC
//
//  Created by NgocAn Pham on 5/2/18.
//  Copyright © 2018 An. All rights reserved.
//
#import <XCDYouTubeKit/XCDYouTubeKit.h>
#import "MPMoviePlayerController+BackgroundPlayback.h"
#import "YoutubeController.h"

@interface YoutubeController ()
@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;
@end

@implementation YoutubeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:@"hKOLILJYArw"];
    self.videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlayVideoInBackground"];
    [self.videoPlayerViewController presentInView:self.view];
    [self.view sendSubviewToBack:self.videoPlayerViewController.moviePlayer.view];
    [self.videoPlayerViewController.moviePlayer prepareToPlay];
    
    self.videoPlayerViewController.moviePlayer.view.frame = self.view.bounds;
    [self.videoPlayerViewController.moviePlayer.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIView* view = self.videoPlayerViewController.moviePlayer.view;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(view);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:viewsDictionary];
    [self.view addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                          options:0
                                                          metrics:nil
                                                            views:viewsDictionary];
    [self.view addConstraints:constraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
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
