@interface CSIconDelegate : NSObject
<<<<<<< HEAD
=======
- (BOOL)iconPositionIsEditable:(id)arg1;
>>>>>>> cb7d7214b8270405dd160e74854fea27d457ef3e
- (void)iconTouchBegan:(SBIconView *)arg1;
- (void)icon:(SBIconView *)arg1 touchEnded:(BOOL)arg2;
- (BOOL)iconShouldAllowTap:(SBIconView *)arg1;
- (void)iconTapped:(SBIconView *)arg1;
<<<<<<< HEAD
- (BOOL)iconViewDisplaysCloseBox:(SBIconView *)arg1;
=======
- (void)iconHandleLongPress:(SBIconView *)arg1;
- (BOOL)iconViewDisplaysCloseBox:(SBIconView *)arg1;
- (void)iconCloseBoxTapped:(SBIconView *)arg1;
>>>>>>> cb7d7214b8270405dd160e74854fea27d457ef3e
@end