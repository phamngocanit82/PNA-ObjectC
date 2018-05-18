@implementation UtilsFont
+(void)changeFont:(UIControl*)control{
    if ([control isKindOfClass:[UIImageView class]]||[control isKindOfClass:[CustomImageView class]]){
        return;
    }
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        if ([control isKindOfClass:[CustomLabel class]]){
            CustomLabel *label = (CustomLabel*)control;
            label.font = [UIFont fontWithName:[UtilsFont fontName] size:label.getFontSize];
            return;
        }
        if ([control isKindOfClass:[CustomButton class]]){
            CustomButton *button = (CustomButton*)control;
            button.titleLabel.font = [UIFont fontWithName:[UtilsFont fontName] size:button.getFontSize];
            return;
        }
        if ([control isKindOfClass:[UITextField class]]||[control isKindOfClass:[CustomTextField class]]){
            UITextField *txt = (UITextField*)control;
            txt.textColor = [UIColor colorWithRed:198/255.f green:160/255.f blue:64/255.f alpha:1];
            return;
        }
        if ([control isKindOfClass:[UITextView class]]){
            UITextView *textView = (UITextView*)control;
            textView.textColor = [UIColor colorWithRed:198/255.f green:160/255.f blue:64/255.f alpha:1];
            //textView.font = [UIFont fontWithName:[UtilsFont fontName] size:textView.font.pointSize+sizeLabel];
            return;
        }
    }else{
        if ([control isKindOfClass:[CustomLabel class]]){
            CustomLabel *label = (CustomLabel*)control;
            label.font = [UIFont fontWithName:[UtilsFont fontName] size:label.getFontSize+5];
            return;
        }
        if ([control isKindOfClass:[CustomButton class]]){
            CustomButton *button = (CustomButton*)control;
            button.titleLabel.font = [UIFont fontWithName:[UtilsFont fontName] size:button.getFontSize+5];
            return;
        }
    }
    for(UIControl *ctr in control.subviews) {
        [UtilsFont changeFont:ctr];
    }
}
+(NSString*)fontName{
    return @"arial";
}
@end
