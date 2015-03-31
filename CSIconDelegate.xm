#import "shared.h"
#import "CSView-New.h"
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
  [[CSView sharedView] activateAppWithContainer:((CSContainer *)arg1.superview)];
  [arg1 setHighlighted:NO];

}
- (BOOL)iconViewDisplaysCloseBox:(SBIconView *)arg1 {
    return NO;
}

@end