@implementation CustomView
-(void)awakeFromNib{
    if(self.drawBorder==YES){
        self.clipsToBounds = YES;
        if(self.borderWidth>0)
            self.layer.borderWidth = self.borderWidth;
        if (!CGColorEqualToColor(self.borderColor.CGColor, [UIColor clearColor].CGColor))
            self.layer.borderColor = self.borderColor.CGColor;
        if(self.cornerRadius>0)
            self.layer.cornerRadius = self.cornerRadius;
    }
    if(self.drawGradient==YES){
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = @[(id)self.gradientFromColor.CGColor, (id)self.gradientToColor.CGColor];
        [self.layer insertSublayer:gradient atIndex:0];
    }
    [super awakeFromNib];
}
@end
