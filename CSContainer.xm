#import "shared.h"
#import "CSContainer.h"
#import "CSView-New.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@implementation CSContainer
- (id)initWithIcon:(SBIcon *)icon snapshot:(id)snapshot {

    self = [super initWithFrame:CGRectMake(0,0,62,98)];
    self.contentSize = CGSizeMake(62,196);
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.clipsToBounds = NO;
    
    
    _icon = icon;
    _iconView = [[%c(SBIconView) alloc] initWithDefaultSize];
    _iconView.icon = _icon;
    _iconView.delegate = [[CSView sharedView] iconDelegate];
    _snapshot = snapshot;
    
    _tapLaunch = [[UITapGestureRecognizer alloc] initWithTarget:[CSView sharedView] action:@selector(tappedContainer:)];
    [self addGestureRecognizer:_tapLaunch];
    
    if (_snapshot != nil) {
      _page = [[%c(SBAppSwitcherPageView) alloc] initWithFrame:CGRectMake(0,0,62,98)];
      _page.backgroundColor = [UIColor clearColor];
      for (UIView *view in ((UIView *)_snapshot).subviews) {
	view.backgroundColor = [UIColor clearColor];
      }
      for (UIView *view in _page.subviews) {
	view.backgroundColor = [UIColor clearColor];
      }
      [_page setView:_snapshot animated:NO];
      [self addSubview:_page];
      
      [_iconView _iconImageView].layer.transform = CATransform3DMakeScale(0.5,0.5,0.5);
      [_iconView setLabelHidden:YES];
      [_iconView _applyIconAccessoryAlpha:0];
      [self addSubview:_iconView];
      
      
      
      [self adjustIconToOrientation];
    }
    else {
      _iconView.frame = CGRectMake(0,15,60,60);
      [self addSubview:_iconView];
    }
    return self;
}

- (void)adjustIconToOrientation {
  int currentOrientation = [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation];
   if (currentOrientation == 3 || currentOrientation == 4) {
    self.contentSize = CGSizeMake(196,62);
    _iconView.frame = CGRectMake(15,0,60,60);
   }
   if (currentOrientation == 1 || currentOrientation == 2) {
    self.contentSize = CGSizeMake(62,196);
    _iconView.frame = CGRectMake(0,15,60,60);
   }
      
  if (_snapshot !=nil) {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
      ((SBAppSwitcherSnapshotView *)_snapshot).orientation = currentOrientation;
      [((SBAppSwitcherSnapshotView *)_snapshot) layoutSubviews];
    }
    else {
      ((SBAppSliderSnapshotView *)_snapshot).orientation = currentOrientation;
      [((SBAppSliderSnapshotView *)_snapshot) layoutSubviews];
    }
    _page.backgroundColor = [UIColor clearColor];
      for (UIView *view in ((UIView *)_snapshot).subviews) {
	view.backgroundColor = [UIColor clearColor];
      }
      for (UIView *view in _page.subviews) {
	view.backgroundColor = [UIColor clearColor];
      }
    if (currentOrientation == 3 || currentOrientation == 4) {
      _iconView.frame = CGRectMake(15,15,30,30);
      _page.frame = CGRectMake(15,-25,62,98);
    }
    if (currentOrientation == 1 || currentOrientation == 2) {
      _iconView.frame = CGRectMake(1.5,45,30,30);
      _page.frame = CGRectMake(0,0,62,98);
    }
   }
}

- (void)launchApp {
  SBApplication *app;
  if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
    app = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:self.id];
  }
  else {
    app = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:self.id];
  }
  [[%c(SBUIController) sharedInstance] activateApplicationAnimated:app];
}

- (void)scrollViewDidScroll:(UIScrollView *)view {
  if (view.contentOffset.y > 98 && view.contentSize.height > 62) {
    self.hidden = YES;
    [[CSView sharedView] removeContainer:self];
  }
  if (view.contentOffset.x > 98 && view.contentSize.width > 62) {
    self.hidden = YES;
    [[CSView sharedView] removeContainer:self];
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)view willDecelerate:(BOOL)decelerate {
  [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationCurveEaseOut
                             animations:^{
			      view.contentOffset = CGPointMake(0,0);
                             }
                             completion:^(BOOL finnished){
                             }];
}

- (void)dealloc {
  
  [_snapshot release];
  _snapshot = nil;
  
  [_iconView release];
  _iconView = nil;
  
  [_icon release];
  _icon = nil;
  
  [_tapLaunch release];
  _tapLaunch = nil;
  
  [_page release];
  _page = nil;
  
  [super dealloc];
}
@end