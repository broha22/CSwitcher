#import "shared.h"
@interface CSView : UIScrollView {
  NSMutableArray *editingBurn;
}
+ (CSView *)sharedView;
- (void)layoutIconsWithIDS:(NSArray *)IDS;
- (void)removeIcon:(SBIconView *)icon;
- (void)setIconsEditing:(BOOL)arg1;
- (void)activateAppWithIconView:(UIView *)icon;
- (void)moveAppToFront:(id)app;
- (id)currentIDS;
- (void)setContainersEditing;
- (void)removeContainerView:(UIView *)view;
- (void)cleanUpKill:(UIView *)view;
- (void)tappedContainer:(UIGestureRecognizer *)recognizer;
- (void)tappedCloseBox:(UIButton *)sender;
- (void)pressedContainer:(UIGestureRecognizer *)recognizer;
- (void)stopContainersEditing;
@property BOOL inEdit;
@property BOOL snapShots;
@end



