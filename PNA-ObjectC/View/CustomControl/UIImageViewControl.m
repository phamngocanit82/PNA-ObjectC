@implementation UIImageViewControl
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
    //[MILImage imageWithPath:self Path:strPath];
}
-(void)backgroundWithPath:(NSString*)strPath{
    //[MILImage imageWithPath:self Path:strPath];
}
@end
