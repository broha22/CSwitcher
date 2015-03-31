#import "shared.h"
#import "CSView.h"
#import "CSIconDelegate.h"
#import "prefs.h"
static int iconCount() {
  if (fivecon()) {
    return 5;
  }
  else {
    return 4;
  }
}

static int calcX (int i) {
if (!fivecon()){
    int extra = 0;
    if (paging()) {
      extra = ceil((i-1)/4) * 16;
    }
    return ((16 * i) + (60 * (i - 1)) + extra);
    }
  else if (fivecon()){
    if (paging()) {
      int page = floor((i-1)/5)*320;
      if (i%5 == 1){
	return 4 + page;
      }
      else {
	return 4 + (((i-1)%5)*3) + page+ (60 * ((i - 1)%5));
      }
      }
     else {
	return (3 * i) + (60 * (i - 1)); 
     }
    }
  else {
    return 0;
  }
}
static CSView *sharedCSView = nil;
static NSMutableArray *currentIDS;
static NSMutableArray *arrayOfSnaps = [[NSMutableArray alloc] init];
static NSMutableArray *containerViewsArray = [[NSMutableArray alloc] init];
static CSIconDelegate *sharedIconDelegate = [[CSIconDelegate alloc] init];

@implementation CSView

+ (CSView *)sharedView {
 if (sharedCSView == nil){
    sharedCSView = [[super alloc] initWithFrame:CGRectMake(0,0,320,98)];
    sharedCSView.bounces = YES;
    sharedCSView.pagingEnabled = paging();
    sharedCSView.showsHorizontalScrollIndicator = NO;
    sharedCSView.showsVerticalScrollIndicator = NO;
    }
   return sharedCSView;
}

- (void)layoutIconsWithIDS:(NSMutableArray *)IDS {
  int currentOrientation = [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation];
  if (currentOrientation == 3 || currentOrientation == 4) {
    self.frame = CGRectMake(0,0,98,320);
  }
  if (currentOrientation == 1 || currentOrientation == 2) {
    self.frame = CGRectMake(0,0,320,98);
  }
  for (SBIconView *view in self.subviews) {
    [view removeFromSuperview];
    if ([view class] == [%c(SBIconView) class]){
      [view release];
    }
   }
  NSArray *tempArray = [arrayOfSnaps copy];
  for (id i in tempArray) {
    [arrayOfSnaps removeObject:i];
    [i release];
  }
  [tempArray release];
   NSArray *tempArray2 = [containerViewsArray copy];
  for (id i in tempArray2) {
    [containerViewsArray removeObject:i];
    [i release];
  }
  [tempArray2 release];
  for (NSString *ID in IDS) {
    if ([IDS indexOfObject:ID] != 0){
      SBIcon *icon = [(SBIconModel *)[[%c(SBIconController) sharedInstance] model] expectedIconForDisplayIdentifier:ID];
      SBIconView *view = [[%c(SBIconView) alloc] initWithDefaultSize];
      view.icon = icon;
      view.tag = [IDS indexOfObject:ID];
      view.delegate = sharedIconDelegate;
      if (currentOrientation == 1 || currentOrientation == 2) {
	[view setLabelHidden:NO];
	view.frame = CGRectMake(calcX([IDS indexOfObject:ID]),16,60,60);
      }
      if (currentOrientation == 3 || currentOrientation == 4) {
	[view setLabelHidden:YES];
	view.frame = CGRectMake(16,calcX([IDS indexOfObject:ID]),60,60);
      }
      [self addSubview:view];
      if (snaps()) {
	UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(calcX([IDS indexOfObject:ID]),0,62,97)];
	SBAppSwitcherSnapshotView *snapView = [[%c(SBAppSwitcherSnapshotView) alloc] initWithDisplayItem:nil application:[[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:ID] orientation:[(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] async:NO withQueue:MSHookIvar<NSObject<OS_dispatch_queue> *>([%c(SBAppSwitcherController) sharedController], "_snapshotQueue") statusBarCache:nil];
	[arrayOfSnaps addObject:snapView];
	SBAppSwitcherPageView *page = [[%c(SBAppSwitcherPageView) alloc] initWithFrame:CGRectMake(0,0,62,97)];
	[page setView:snapView animated:NO];
	for (UIView *view in page.subviews) {
	  view.backgroundColor = [UIColor clearColor];
	}
	if (currentOrientation == 3 || currentOrientation == 4) {
	  page.frame = CGRectMake(0,0,53,94);
	  containerView.frame = CGRectMake(20,calcX(view.tag)-19,97,62);
	}
	[arrayOfSnaps addObject:page];
	[containerView addSubview:page];
	view.frame = CGRectMake(1.5,45,30,30);
	if (currentOrientation == 3 || currentOrientation == 4) {
	  view.frame = CGRectMake(-3,35,30,30);
	}
	[view _iconImageView].layer.transform = CATransform3DMakeScale(0.5,0.5,0.5);
	[view setLabelHidden:YES];
	[view _applyIconAccessoryAlpha:0];
	[view removeFromSuperview];
	[containerView addSubview:view];
	[containerViewsArray addObject:containerView];
	UITapGestureRecognizer *tapLaunch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedContainer:)];
	[containerView addGestureRecognizer:tapLaunch];
	UILongPressGestureRecognizer *pressEdit = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedContainer:)];
	[containerView addGestureRecognizer:pressEdit];
	[arrayOfSnaps addObject:pressEdit];
	[arrayOfSnaps addObject:tapLaunch];
	containerView.tag = [IDS indexOfObject:ID];
	[self addSubview:containerView];
	self.snapShots = YES;
      }
      
    }
  } 
    currentIDS = IDS;
   [self adjustContentSize];
  
}

- (void)removeIcon:(SBIconView *)icon {
  int currentOrientation = [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation];
  [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationCurveEaseIn
                             animations:^{
			      icon.layer.transform = CATransform3DMakeScale(0.01,0.01,0.01);
                             }
                             completion:^(BOOL finnished){
				[self cleanUpKill:icon];
                             }];
   for (UIView *view in self.subviews){
    if ([view class] == [%c(SBIconView) class] && icon.tag < view.tag) {
      view.tag--;
      [UIView animateWithDuration:0.25f delay:0.05f options:UIViewAnimationCurveEaseOut
                             animations:^{
			      if (currentOrientation == 1 || currentOrientation == 2) {
				  view.frame = CGRectMake(calcX(view.tag),16,60,60);
			      }
			      if (currentOrientation == 3 || currentOrientation == 4) {
				  view.frame = CGRectMake(16,calcX(view.tag),60,60);
			      }
                             }
                             completion:^(BOOL finnished){
                             }];
    }
   }
  [self adjustContentSize];
   
}

- (void)setIconsEditing:(BOOL)arg1 {
  for (SBIconView *view in [CSView sharedView].subviews){
    if ([view class] == [%c(SBIconView) class]){
      [view setIsEditing:arg1 animated:YES];
      self.inEdit = arg1;
    }
  }
}

- (void)activateAppWithIconView:(UIView *)icon {
  SBApplication *app = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:[currentIDS objectAtIndex:icon.tag]];
  [[%c(SBUIController) sharedInstance] activateApplicationAnimated:app];
}

- (void)moveAppToFront:(id)app {
  [currentIDS removeObject:app];
  [currentIDS insertObject:app atIndex:1];
  [self layoutIconsWithIDS:currentIDS];

  
}
- (id)currentIDS {
  return currentIDS;
}
- (void)setContainersEditing {
  if (!self.inEdit){
    int currentOrientation = [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation];
    editingBurn = [[NSMutableArray alloc] init];
    for (UIView *view in containerViewsArray) {
      SBCloseBoxView *closeBox = [[%c(SBCloseBoxView) alloc] initWithFrame:CGRectMake(-5,-1,24,24)];
      if (currentOrientation == 3 || currentOrientation == 4) {
	  closeBox.frame = CGRectMake(-19.5,13.5,24,24);
	}
      [closeBox addTarget:self action:@selector(tappedCloseBox:) forControlEvents:UIControlEventTouchUpInside];
      [editingBurn addObject:closeBox];
      [view addSubview:closeBox];
      closeBox.layer.transform = CATransform3DMakeScale(0.01,0.01,0.01);
      [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationCurveEaseIn
                             animations:^{
			      closeBox.layer.transform = CATransform3DIdentity;
                             }
                             completion:^(BOOL finnished){
                             }];
    } 
    self.inEdit = YES;
  }
}
- (void)stopContainersEditing {
  for (UIView *view in editingBurn) {
      [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationCurveEaseIn
                             animations:^{
			      view.layer.transform = CATransform3DMakeScale(0.01,0.01,0.01);
                             }
                             completion:^(BOOL finnished){
				[view removeFromSuperview];
                             }];
    [view release];
    }
    
  [editingBurn release];
  self.inEdit = NO;
}
- (void)removeContainerView:(UIView *)view {
  int currentOrientation = [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation];
  [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationCurveEaseIn
                             animations:^{
			      view.layer.transform = CATransform3DMakeScale(0.01,0.01,0.01);
                             }
                             completion:^(BOOL finnished){
				[self cleanUpKill:view];
                             }];
   for (UIView *view2 in containerViewsArray){
   if (view.tag < view2.tag){
      view2.tag--;
      [UIView animateWithDuration:0.25f delay:0.05f options:UIViewAnimationCurveEaseOut
                             animations:^{
			      if (currentOrientation == 1 || currentOrientation == 2) {
				  view2.frame = CGRectMake(calcX(view2.tag),0,62,97);
			      }
			      if (currentOrientation == 3 || currentOrientation == 4) {
				  view2.frame = CGRectMake(20,calcX(view2.tag)-19,97,62);
			      }
                             }
                             completion:^(BOOL finnished){
                             }];
   }
   }
  [self adjustContentSize];
}
- (void)cleanUpKill:(UIView *)view {
  [view removeFromSuperview];
  [[%c(SBAppSwitcherModel) sharedInstance] remove:[currentIDS objectAtIndex:view.tag]];
  SBApplication *app = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:[currentIDS objectAtIndex:view.tag]];
  system([[NSString stringWithFormat:@"killall %@", [[[app bundle] executablePath] lastPathComponent]] UTF8String]);
  [currentIDS removeObjectAtIndex:view.tag];
}
- (void)tappedContainer:(UIGestureRecognizer *)recognizer {
  if (!self.inEdit){
    [self activateAppWithIconView:recognizer.view];
  }
}
- (void)tappedCloseBox:(UIButton *)sender {
  [self removeContainerView:sender.superview];
}
- (void)pressedContainer:(UIGestureRecognizer *)recognizer {
  [self setContainersEditing];
}
- (void)adjustContentSize {
  int currentOrientation = [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation];
  if (paging()){
   if (currentOrientation == 1 || currentOrientation == 2) {
	self.contentSize = CGSizeMake((int)(([currentIDS count]+iconCount()-2)/iconCount()) * 320,98);
   }
   if (currentOrientation == 3 || currentOrientation == 4) {
	self.contentSize = CGSizeMake(98,(int)(([currentIDS count]+iconCount()-2)/iconCount()) * 320);
   }
  }
  if (!paging()){
      float inBetween = (320 - (iconCount() * 60))/(iconCount() + 1);
   if (currentOrientation == 1 || currentOrientation == 2) {
	self.contentSize = CGSizeMake((60 * ([currentIDS count]-1))+([currentIDS count] * inBetween),98);
   }
   if (currentOrientation == 3 || currentOrientation == 4) {
	self.contentSize = CGSizeMake(98,(60 * ([currentIDS count]-1))+([currentIDS count] * inBetween));
   }
  }
}
@end