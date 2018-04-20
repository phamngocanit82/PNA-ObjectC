@implementation UITextFieldControl
#pragma mark - Initializer
-(void)awakeFromNib{
    if(self.keyPlaceHolder!=nil){
        if ([self.keyPlaceHolder length]>0)
            self.placeholder = [LanguageService language:self.keyPlaceHolder];
    }
    [super awakeFromNib];
}
-(NSString*)textTrimming{
    return [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
@end
