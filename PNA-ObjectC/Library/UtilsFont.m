@implementation UtilsFont
+(void)changeFont:(UIControl*)control increaseFont:(BOOL)flag{
    NSInteger sizeLabel = 0;
    NSInteger sizeButton = 0;
    if ([control isKindOfClass:[UIImageView class]]||[control isKindOfClass:[UIImageViewControl class]]){
        return;
    }
    if ([control isKindOfClass:[UILabel class]]||[control isKindOfClass:[UILabelControl class]]){
        UILabel *label = (UILabel*)control;
        label.font = [UIFont fontWithName:[UtilsFont fontName] size:label.font.pointSize+sizeLabel];
        return;
    }
    if ([control isKindOfClass:[UIButton class]]||[control isKindOfClass:[UIButtonControl class]]){
        UIButton *button = (UIButton*)control;
        button.titleLabel.font = [UIFont fontWithName:[UtilsFont fontName] size:button.titleLabel.font.pointSize+sizeButton];
        return;
    }
    if ([control isKindOfClass:[UITextField class]]||[control isKindOfClass:[UITextFieldControl class]]){
        UITextField *txt = (UITextField*)control;
        txt.textColor = [UIColor colorWithRed:198/255.f green:160/255.f blue:64/255.f alpha:1];
        return;
    }
    if ([control isKindOfClass:[UITextView class]]){
        UITextView *textView = (UITextView*)control;
        textView.textColor = [UIColor colorWithRed:198/255.f green:160/255.f blue:64/255.f alpha:1];
        textView.font = [UIFont fontWithName:[UtilsFont fontName] size:textView.font.pointSize+sizeLabel];
        return;
    }
    for(UIControl *ctr in control.subviews) {
        [UtilsFont changeFont:ctr increaseFont:flag];
    }
}
+(NSString*)fontName{
    return @"arial";
}
@end
