#import "shared.h"
<<<<<<< HEAD
#import "CSView-New.h"
=======
#import "CSView.h"
>>>>>>> cb7d7214b8270405dd160e74854fea27d457ef3e
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
<<<<<<< HEAD
  [[CSView sharedView] activateAppWithContainer:((CSContainer *)arg1.superview)];
  [arg1 setHighlighted:NO];

}
- (BOOL)iconViewDisplaysCloseBox:(SBIconView *)arg1 {
    return NO;
=======
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
>>>>>>> cb7d7214b8270405dd160e74854fea27d457ef3e
}

@end