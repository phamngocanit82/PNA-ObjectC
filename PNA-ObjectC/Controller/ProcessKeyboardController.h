#import "RefreshTableHeaderController.h"
@interface ProcessKeyboardController : RefreshTableHeaderController{
    UITextField *activeField;
    UITextView *activeView;
    float keepHeight;
    float heightKeyboard;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topHeaderViewLayoutConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomHeaderViewLayoutConstraint;

-(void)keyboardWasShown;

-(void)keyboardWillHide;

-(void)moveView;

-(void)actionSearch;

-(void)actionHandleSingleTap;
@end
