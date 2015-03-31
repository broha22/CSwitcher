#import "shared.h"
@interface CSContainer : UIScrollView <UIScrollViewDelegate> {
  id _snapshot;
  SBIcon *_icon;
  UITapGestureRecognizer *_tapLaunch;
  SBIconView *_iconView;
  SBAppSwitcherPageView *_page;
}
- (id)initWithIcon:(SBIcon *)icon snapshot:(id)snapshot;
- (void)adjustIconToOrientation;
- (void)launchApp;
- (void)scrollViewDidScroll:(UIScrollView *)view;
@property (retain) NSString *id;
@end