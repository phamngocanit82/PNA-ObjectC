#import "ProcessKeyboardController.h"
@implementation ProcessKeyboardController
-(void)viewDidLoad{
    [super viewDidLoad];
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:tapper];
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender{
    [self.view endEditing:YES];
    if ([self respondsToSelector:@selector(actionHandleSingleTap)]){
        [self actionHandleSingleTap];
    }
}
-(void)viewWillAppear: (BOOL)animated{
    keepHeight = 0;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear: (BOOL)animated{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (keepHeight==0){
        keepHeight = kbSize.height;
    }
    if (heightKeyboard==0) {
        heightKeyboard = keepHeight;
        [self moveView];
    }
    heightKeyboard = keepHeight;
    if ([self respondsToSelector:@selector(keyboardWasShown)]){
        [self keyboardWasShown];
    }
}
-(void)keyboardWillBeHidden:(NSNotification*)aNotification{
    heightKeyboard = 0;
    if ([self respondsToSelector:@selector(keyboardWillHide)]){
        [self keyboardWillHide];
    }
    [self resetView];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
    activeView = nil;
    if (heightKeyboard>0){
        [self moveView];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    activeField = nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType==UIReturnKeySearch) {
        if ([self respondsToSelector:@selector(actionSearch)]) {
            [self actionSearch];
        }
    }
    [self.view endEditing:YES];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    activeField = nil;
    activeView = textView;
    if (heightKeyboard>0){
        [self moveView];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    activeView = nil;
}
-(BOOL)textViewShouldReturn:(UITextView *)textView {
    [self.view endEditing:YES];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.tag==CHECK_VALID_EMAIL){
        if([string length]>0){
            if([Utils checkEmail:string])
                return NO;
        }
    }else if (textField.tag>0) {
        string = [string stringByReplacingOccurrencesOfString:@"," withString:@"."];
        if ([textField.text rangeOfString:@"."].location != NSNotFound){
            if ([string hasPrefix:@","]||[string hasPrefix:@"."]) {
                return NO;
            }
        }
        if([Utils checkNumeric:string]==NO){
            return NO;
        }
        NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (textField.text.length >= textField.tag && range.length == 0){
            return NO;
        }else{
            activeField.text = [searchStr stringByReplacingOccurrencesOfString:@"," withString:@"."];
            return NO;
        }
    }
    return YES;
}
-(void)moveView{
    if (activeField) {
        self.topHeaderViewLayoutConstraint.constant = 0;
        self.bottomHeaderViewLayoutConstraint.constant = 0;
        [self.view layoutIfNeeded];
        CGPoint pointInWindow = [activeField.superview convertPoint:activeField.center toView:nil];
        CGPoint pointInScreen = [activeField.window convertPoint:pointInWindow toWindow:nil];
        float yKeyboard = [UtilsPlatform getHeight] - heightKeyboard;
        if (pointInScreen.y+activeField.frame.size.height*2-yKeyboard>0) {
            self.topHeaderViewLayoutConstraint.constant = -(pointInScreen.y+activeField.frame.size.height*2-yKeyboard);
            self.bottomHeaderViewLayoutConstraint.constant = (pointInScreen.y+activeField.frame.size.height*2-yKeyboard);
            [self.view layoutIfNeeded];
        }
    }
}
-(void)resetView{
    self.topHeaderViewLayoutConstraint.constant = 0;
    self.bottomHeaderViewLayoutConstraint.constant = 0;
    [self.view layoutIfNeeded];
}
@end
