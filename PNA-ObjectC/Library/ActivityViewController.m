#import "ActivityViewController.h"
@implementation ActivityViewController
- (BOOL)_shouldExcludeActivityType:(UIActivity *)activity{
    if([[super excludedActivityTypes]containsObject:@"com.apple.reminders.RemindersEditorExtension"] || [[activity activityType] isEqualToString:@"com.apple.mobilenotes.SharingExtension"]){
        return YES;
    }
    if([[activity activityType] isEqualToString:@"com.apple.reminders.RemindersEditorExtension"] || [[activity activityType] isEqualToString:@"com.apple.mobilenotes.SharingExtension"]){
        return YES;
    }
    return [[super excludedActivityTypes]containsObject:activity.activityType];
}
@end
