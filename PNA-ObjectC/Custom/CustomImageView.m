#import "DGActivityIndicatorView.h"
@implementation CustomImageView
-(void)awakeFromNib{
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    if(self.drawBorder==YES){
        if(self.borderWidth>0)
            self.layer.borderWidth = self.borderWidth;
        if (!CGColorEqualToColor(self.borderColor.CGColor, [UIColor clearColor].CGColor))
            self.layer.borderColor = self.borderColor.CGColor;
        if(self.cornerRadius>0)
            self.layer.cornerRadius = self.cornerRadius;
    }
    [super awakeFromNib];
}
-(void)imageWithPath:(NSString*)strPath{
    [self imageWithPath:self Path:strPath];
}
-(void)backgroundWithPath:(NSString*)strPath{
    [self imageWithPath:self Path:strPath];
}
-(void)imageWithPath:(NSObject*)object Path:(NSString*)strPath{
    strPath = [strPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *className = NSStringFromClass([object class]);
    className = [className stringByReplacingOccurrencesOfString:@"CustomImageView" withString:@"UIImageView"];
    className = [className stringByReplacingOccurrencesOfString:@"CustomButton" withString:@"UIButton"];
    NSArray *array = @[@"UIImageView", @"UIButton"];
    NSUInteger index = [array indexOfObject:className];
    switch (index) {
        case 0:{
            UIImageView *imageView = (UIImageView*)object;
            [self addAnimation:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:strPath]
                         placeholderImage:nil
                                  options:SDWebImageProgressiveDownload
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *url) {
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    imageView.image = image;
                                    [self removeAnimation:imageView];
                                }];
        }
            break;
        case 1:{
            UIButton *button = (UIButton*)object;
            [button sd_setImageWithURL:[NSURL URLWithString:strPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_wait_loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
            
        }
            break;
    }
}
-(void)removeAnimation:(NSObject*)object{
    CustomImageView *imageView = (CustomImageView*)object;
    CustomView *contentView = [imageView viewWithTag:50];
    if(contentView){
        CustomView *animationView = [contentView viewWithTag:51];
        DGActivityIndicatorView *activityIndicatorView = (DGActivityIndicatorView*)[animationView viewWithTag:52];
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        activityIndicatorView = nil;
        [contentView removeFromSuperview];
        contentView = nil;
    }
}
-(void)addAnimation:(NSObject*)object{
    CustomImageView *imageView = (CustomImageView*)object;
    CustomView *contentView = [imageView viewWithTag:50];
    if(!contentView){
        if(imageView.frame.size.width<=70&&imageView.frame.size.height<=70){
            if(imageView.frame.size.width<=60&&imageView.frame.size.height<=60){
                CustomView *contentView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width , imageView.frame.size.height)];
                contentView.tag = 50;
                contentView.backgroundColor = [UIColor whiteColor];
                CustomView *animationView = [[CustomView alloc] initWithFrame:CGRectMake((contentView.frame.size.width-54)/2, (contentView.frame.size.height-60)/2, 54 , 54)];
                animationView.backgroundColor = [UIColor whiteColor];
                animationView.tag = 51;
                DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader tintColor:[UIColor colorWithRed:0 green:157/255.f blue:48/255.f alpha:1]];
                activityIndicatorView.tag = 52;
                activityIndicatorView.size = 16;
                activityIndicatorView.frame = CGRectMake((animationView.frame.size.width-10)/2, 10, 10, 10);
                [animationView addSubview:activityIndicatorView];
                [activityIndicatorView startAnimating];
                
                CustomLabel *loadingLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(0, animationView.frame.size.height-30, animationView.frame.size.width , 15)];
                loadingLabel.tag = 53;
                loadingLabel.text = @"Picture is loading...";
                loadingLabel.textAlignment = NSTextAlignmentCenter;
                loadingLabel.textColor = [UIColor blackColor];
                loadingLabel.font = [UIFont fontWithName:[UtilsFont fontName] size:6];
                [animationView addSubview:loadingLabel];
                
                CustomLabel *pleaseWaitLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(0, animationView.frame.size.height-15, animationView.frame.size.width , 15)];
                pleaseWaitLabel.tag = 54;
                pleaseWaitLabel.text = @"Please wait";
                pleaseWaitLabel.textAlignment = NSTextAlignmentCenter;
                pleaseWaitLabel.textColor = [UIColor blackColor];
                pleaseWaitLabel.font = [UIFont fontWithName:[UtilsFont fontName] size:6];
                [animationView addSubview:pleaseWaitLabel];
                [contentView addSubview:animationView];
                
                [imageView addSubview:contentView];
            }else{
                CustomView *contentView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width , imageView.frame.size.height)];
                contentView.tag = 50;
                contentView.backgroundColor = [UIColor whiteColor];
                CustomView *animationView = [[CustomView alloc] initWithFrame:CGRectMake((contentView.frame.size.width-60)/2, (contentView.frame.size.height-60)/2, 60 , 60)];
                animationView.backgroundColor = [UIColor whiteColor];
                animationView.tag = 51;
                DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader tintColor:[UIColor colorWithRed:0 green:157/255.f blue:48/255.f alpha:1]];
                activityIndicatorView.tag = 52;
                activityIndicatorView.size = 20;
                activityIndicatorView.frame = CGRectMake((animationView.frame.size.width-10)/2, 10, 10, 10);
                [animationView addSubview:activityIndicatorView];
                [activityIndicatorView startAnimating];
                
                CustomLabel *loadingLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(0, animationView.frame.size.height-30, animationView.frame.size.width , 15)];
                loadingLabel.tag = 53;
                loadingLabel.text = @"Picture is loading...";
                loadingLabel.textAlignment = NSTextAlignmentCenter;
                loadingLabel.textColor = [UIColor blackColor];
                loadingLabel.font = [UIFont fontWithName:[UtilsFont fontName] size:7];
                [animationView addSubview:loadingLabel];
                
                CustomLabel *pleaseWaitLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(0, animationView.frame.size.height-15, animationView.frame.size.width , 15)];
                pleaseWaitLabel.tag = 54;
                pleaseWaitLabel.text = @"Please wait";
                pleaseWaitLabel.textAlignment = NSTextAlignmentCenter;
                pleaseWaitLabel.textColor = [UIColor blackColor];
                pleaseWaitLabel.font = [UIFont fontWithName:[UtilsFont fontName] size:7];
                [animationView addSubview:pleaseWaitLabel];
                [contentView addSubview:animationView];
                
                [imageView addSubview:contentView];
            }
            
        }else{
            if(imageView.frame.size.width<=76&&imageView.frame.size.height<=76){
                CustomView *contentView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width , imageView.frame.size.height)];
                contentView.tag = 50;
                contentView.backgroundColor = [UIColor whiteColor];
                CustomView *animationView = [[CustomView alloc] initWithFrame:CGRectMake((contentView.frame.size.width-70)/2, (contentView.frame.size.height-70)/2, 70 , 70)];
                animationView.backgroundColor = [UIColor whiteColor];
                animationView.tag = 51;
                DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader tintColor:[UIColor colorWithRed:0 green:157/255.f blue:48/255.f alpha:1]];
                activityIndicatorView.tag = 52;
                activityIndicatorView.size = 24;
                activityIndicatorView.frame = CGRectMake((animationView.frame.size.width-10)/2, 10, 10, 10);
                [animationView addSubview:activityIndicatorView];
                [activityIndicatorView startAnimating];
                
                CustomLabel *loadingLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(0, animationView.frame.size.height-40, animationView.frame.size.width , 20)];
                loadingLabel.tag = 53;
                loadingLabel.text = @"Picture is loading...";
                loadingLabel.textAlignment = NSTextAlignmentCenter;
                loadingLabel.textColor = [UIColor blackColor];
                loadingLabel.font = [UIFont fontWithName:[UtilsFont fontName] size:9];
                [animationView addSubview:loadingLabel];
                
                CustomLabel *pleaseWaitLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(0, animationView.frame.size.height-25, animationView.frame.size.width , 20)];
                pleaseWaitLabel.tag = 54;
                pleaseWaitLabel.text = @"Please wait";
                pleaseWaitLabel.textAlignment = NSTextAlignmentCenter;
                pleaseWaitLabel.textColor = [UIColor blackColor];
                pleaseWaitLabel.font = [UIFont fontWithName:[UtilsFont fontName] size:9];
                [animationView addSubview:pleaseWaitLabel];
                [contentView addSubview:animationView];
                
                [imageView addSubview:contentView];
            }else{
                CustomView *contentView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width , imageView.frame.size.height)];
                contentView.tag = 50;
                contentView.backgroundColor = [UIColor whiteColor];
                CustomView *animationView = [[CustomView alloc] initWithFrame:CGRectMake((contentView.frame.size.width-80)/2, (contentView.frame.size.height-80)/2, 80 , 80)];
                animationView.backgroundColor = [UIColor whiteColor];
                animationView.tag = 51;
                DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader tintColor:[UIColor colorWithRed:0 green:157/255.f blue:48/255.f alpha:1]];
                activityIndicatorView.tag = 52;
                activityIndicatorView.size = 30;
                activityIndicatorView.frame = CGRectMake((animationView.frame.size.width-10)/2, 10, 10, 10);
                [animationView addSubview:activityIndicatorView];
                [activityIndicatorView startAnimating];
                
                CustomLabel *loadingLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(0, animationView.frame.size.height-45, animationView.frame.size.width , 20)];
                loadingLabel.tag = 53;
                loadingLabel.text = @"Picture is loading...";
                loadingLabel.textAlignment = NSTextAlignmentCenter;
                loadingLabel.textColor = [UIColor blackColor];
                loadingLabel.font = [UIFont fontWithName:[UtilsFont fontName] size:9];
                [animationView addSubview:loadingLabel];
                
                CustomLabel *pleaseWaitLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(0, animationView.frame.size.height-25, animationView.frame.size.width , 20)];
                pleaseWaitLabel.tag = 54;
                pleaseWaitLabel.text = @"Please wait";
                pleaseWaitLabel.textAlignment = NSTextAlignmentCenter;
                pleaseWaitLabel.textColor = [UIColor blackColor];
                pleaseWaitLabel.font = [UIFont fontWithName:[UtilsFont fontName] size:9];
                [animationView addSubview:pleaseWaitLabel];
                [contentView addSubview:animationView];
                
                [imageView addSubview:contentView];
            }
        }
    }
}
@end
