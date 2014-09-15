#import "shared.h"
#import "CSView.h"
#import "CSIconDelegate.h"


@implementation CSIconDelegate
- (BOOL)iconPositionIsEditable:(id)arg1 {
  return NO;
}
- (void)iconTouchBegan:(SBIconView *)arg1 {
  [arg1 setHighlighted:YES];
}
- (void)icon:(SBIconView *)arg1 touchEnded:(BOOL)arg2 {
  [arg1 setHighlighted:NO];
}
- (BOOL)iconShouldAllowTap:(SBIconView *)arg1 {
  return YES;
}
- (void)iconTapped:(SBIconView *)arg1 {
  [[CSView sharedView] activateAppWithIconView:arg1];
  [arg1 setHighlighted:NO];

}
- (void)iconHandleLongPress:(SBIconView *)arg1 {
  if ([CSView sharedView].snapShots == NO){
   [[CSView sharedView] setIconsEditing:YES];
  }
  else {
  
  }
}
- (BOOL)iconViewDisplaysCloseBox:(SBIconView *)arg1 {
  if ([CSView sharedView].snapShots == NO) {
    return YES;
  }
    else {
    return NO;
  }
}
- (void)iconCloseBoxTapped:(SBIconView *)arg1 {
  [[CSView sharedView] removeIcon:arg1];
}

@end