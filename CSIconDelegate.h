@interface CSIconDelegate : NSObject
- (void)iconTouchBegan:(SBIconView *)arg1;
- (void)icon:(SBIconView *)arg1 touchEnded:(BOOL)arg2;
- (BOOL)iconShouldAllowTap:(SBIconView *)arg1;
- (void)iconTapped:(SBIconView *)arg1;
- (BOOL)iconViewDisplaysCloseBox:(SBIconView *)arg1;
@end