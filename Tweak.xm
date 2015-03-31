<<<<<<< HEAD
#import "CSView-New.h"
#import "shared.h"
#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static BOOL enable(void) {
    NSNumber *enable = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enable" inDomain:@"com.broganminer.cswitcher~prefs"];
    return (enable)? [enable boolValue]:YES;
}

static SBControlCenterSectionView *CSSection;
static CGFloat CCHeight;
%group CSwitcher

%hook SBAppSwitcherController
%new
+ (id)sharedController {
  return [(SBUIController *)[%c(SBUIController) sharedInstance] _appSwitcherController];
=======
#import "CSView.h"
#import "shared.h"
static BOOL enable(void) {
    NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.broganminer.cswitcher~prefs.plist"];
    BOOL enable = (prefs)? [prefs [@"enable"] boolValue] : YES;
    [prefs release];
    return enable;
}

static SBControlCenterSectionView *CSContainer;
static SBControlCenterSeparatorView *CSSeparator;
static int oldOrientation;
static CGFloat CCHeight;
%group CSwitcher

%hook SBAppSliderController
%new
+ (id)sharedController {
  return [(SBUIController *)[%c(SBUIController) sharedInstance] _appSliderController];
>>>>>>> cb7d7214b8270405dd160e74854fea27d457ef3e
}
%end

%hook SBControlCenterController
- (void)_endPresentation {
  %orig;
<<<<<<< HEAD
  [CSView sharedView].contentOffset = CGPointMake(0,0);
}
=======
  if ([CSView sharedView].inEdit){
    if (![CSView sharedView].snapShots) {
      [[CSView sharedView] setIconsEditing:NO];
    }
    else {
      [[CSView sharedView] stopContainersEditing];
    }
  } 
  [CSView sharedView].contentOffset = CGPointMake(0,0);
}
- (BOOL)handleMenuButtonTap {
  if ([CSView sharedView].inEdit){
    if (![CSView sharedView].snapShots) {
      [[CSView sharedView] setIconsEditing:NO];
    }
    else {
      [[CSView sharedView] stopContainersEditing];
    }
    return YES;
  }
  else {
    return %orig;
  }
}
>>>>>>> cb7d7214b8270405dd160e74854fea27d457ef3e
%end

%hook SBUIController
- (BOOL)handleMenuDoubleTap {
  [[%c(SBControlCenterController) sharedInstance] presentAnimated:YES];
  return YES;
}

%end

%hook SBAppSwitcherModel
- (void)addToFront:(id)arg1 {
  %orig(arg1);
  [[CSView sharedView] moveAppToFront:arg1];
}
%end
<<<<<<< HEAD

%hook SBIconModel
- (void)removeIcon:(id)arg1 {
  %orig(arg1);
  NSArray *arrayCopy = [[[CSView sharedView] containers] copy];
  for (CSContainer *container in arrayCopy) {
    if ([[((SBIcon *)arg1) applicationBundleID] isEqualToString:container.id]) {
      [[CSView sharedView] cleanUpKill:container];
    }
  }
  [arrayCopy release];
}
%end

%hook SBControlCenterViewController
- (CGFloat)contentHeightForOrientation:(int)orientation {
  if (![(SpringBoard *)[%c(SpringBoard) sharedApplication] isLocked] && (orientation == 1 || orientation == 2)) {
    CCHeight = %orig+98;
    CSSection.hidden = NO;
  }
  else if (![(SpringBoard *)[%c(SpringBoard) sharedApplication] isLocked] && (orientation == 3 || orientation == 4)) {
    CCHeight = %orig;
    CSSection.hidden = NO;
  }
  else {
    CCHeight = %orig;
    CSSection.hidden = YES;
=======
%hook SBControlCenterViewController
- (CGFloat)contentHeightForOrientation:(int)orientation {
  if (![(SpringBoard *)[%c(SpringBoard) sharedApplication] isLocked] && (orientation == 1 || orientation == 2)) {
    CSContainer.layer.hidden = NO;
    CSSeparator.layer.hidden = NO;
    CCHeight = %orig+98;
  }
  else if ([(SpringBoard *)[%c(SpringBoard) sharedApplication] isLocked]) {
    CSContainer.layer.hidden = YES;
    CSSeparator.layer.hidden = YES;
    CCHeight = %orig;
  }
  else {
    CSContainer.layer.hidden = NO;
    CCHeight = %orig;
>>>>>>> cb7d7214b8270405dd160e74854fea27d457ef3e
  }
  return CCHeight;
}
%end
<<<<<<< HEAD

=======
>>>>>>> cb7d7214b8270405dd160e74854fea27d457ef3e
%hook SBControlCenterContentView
- (void)layoutSubviews {
  %orig;
  int currentOrientation = [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation];
<<<<<<< HEAD
  if (!CSSection){
    CSSection = [[[%c(SBControlCenterSectionView) alloc] initWithFrame:CGRectMake(0,CCHeight-100,320,98)] autorelease];
  }
  [self.superview addSubview:CSSection];
  [CSSection addSubview:[CSView sharedView]];
  
  
  if ([[CSView sharedView] containers] == nil){
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
      [[CSView sharedView] createCSContainersWithIDS:[[%c(SBAppSwitcherModel) sharedInstance] snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary]];
    }
    else {
      [[CSView sharedView] createCSContainersWithIDS:[[%c(SBAppSwitcherModel) sharedInstance] identifiers]];

    }
  }
    
  [[CSView sharedView] positionContainers];
    [((SBControlCenterSectionView *)self.airplaySection.view).leftSection layoutSubviews];

  if ((currentOrientation == 1 || currentOrientation == 2) && ![(SpringBoard *)[%c(SpringBoard) sharedApplication] isLocked]){
      CSSection.frame = CGRectMake(0,CCHeight-100,DEVICE_WIDTH,98);
      self.quickLaunchSection.view.frame = CGRectMake(self.quickLaunchSection.view.frame.origin.x,self.quickLaunchSection.view.frame.origin.y,self.quickLaunchSection.view.frame.size.width,self.quickLaunchSection.view.frame.size.height-98);
  }
  
  if ((currentOrientation == 3 || currentOrientation == 4) && ![(SpringBoard *)[%c(SpringBoard) sharedApplication] isLocked]){
    self.quickLaunchSection.view.frame = CGRectMake(self.quickLaunchSection.view.frame.origin.x-98,self.quickLaunchSection.view.frame.origin.y,self.quickLaunchSection.view.frame.size.width,self.quickLaunchSection.view.frame.size.height);
    self.brightnessSection.view.frame = CGRectMake(self.brightnessSection.view.frame.origin.x,self.brightnessSection.view.frame.origin.y,self.brightnessSection.view.frame.size.width-100,self.brightnessSection.view.frame.size.height);
    self.mediaControlsSection.view.frame = CGRectMake(self.mediaControlsSection.view.frame.origin.x,self.mediaControlsSection.view.frame.origin.y,self.mediaControlsSection.view.frame.size.width-100,self.mediaControlsSection.view.frame.size.height);
    self.airplaySection.view.frame = CGRectMake(self.airplaySection.view.frame.origin.x,self.airplaySection.view.frame.origin.y,self.airplaySection.view.frame.size.width-100,self.airplaySection.view.frame.size.height);
    CSSection.frame = CGRectMake(self.frame.size.width - 100,0,98,DEVICE_WIDTH);
=======
  if (!CSContainer){
    CSContainer = [[[%c(SBControlCenterSectionView) alloc] initWithFrame:CGRectMake(0,CCHeight-100,320,98)] autorelease];
  }
  [self.superview addSubview:CSContainer];
  [CSContainer addSubview:[CSView sharedView]];
  if ([[CSView sharedView] currentIDS] == nil){
      [[CSView sharedView] layoutIconsWithIDS:[[%c(SBAppSliderController) sharedController] _beginAppListAccess]];
    }
  if (oldOrientation != currentOrientation) {
    [[CSView sharedView] layoutIconsWithIDS:[[CSView sharedView] currentIDS]];
  }
  oldOrientation = currentOrientation;
  if (!CSSeparator){
    CSSeparator = [[%c(SBControlCenterSeparatorView) alloc] initWithFrame:CGRectMake(0,CSContainer.frame.origin.y-4,320,1)];
    }    
    [self addSubview:CSSeparator];
  if (currentOrientation == 1 || currentOrientation == 2){
  self.quickLaunchSection.view.frame = CGRectMake(self.quickLaunchSection.view.frame.origin.x,self.quickLaunchSection.view.frame.origin.y-3,320,95);
  CSSeparator.layer.hidden = NO;
  CSContainer.frame = CGRectMake(0,CCHeight-100,320,98);
  CSSeparator.frame = CGRectMake(0,CSContainer.frame.origin.y-4,320,1);
}
if (currentOrientation == 3 || currentOrientation == 4){
  self.quickLaunchSection.view.frame = CGRectMake(self.quickLaunchSection.view.frame.origin.x-98,self.quickLaunchSection.view.frame.origin.y,self.quickLaunchSection.view.frame.size.width,self.quickLaunchSection.view.frame.size.height);
  self.brightnessSection.view.frame = CGRectMake(self.brightnessSection.view.frame.origin.x,self.brightnessSection.view.frame.origin.y,self.brightnessSection.view.frame.size.width-100,self.brightnessSection.view.frame.size.height);
  self.mediaControlsSection.view.frame = CGRectMake(self.mediaControlsSection.view.frame.origin.x,self.mediaControlsSection.view.frame.origin.y,self.mediaControlsSection.view.frame.size.width-100,self.mediaControlsSection.view.frame.size.height);
  self.airplaySection.view.frame = CGRectMake(self.airplaySection.view.frame.origin.x,self.airplaySection.view.frame.origin.y,self.airplaySection.view.frame.size.width-100,self.airplaySection.view.frame.size.height);
  CSSeparator.layer.hidden = YES;
  CSContainer.frame = CGRectMake(self.frame.size.width - 100,0,98,320);
>>>>>>> cb7d7214b8270405dd160e74854fea27d457ef3e
  for (UIView *view in self.subviews) {
    if ([view class] == [%c(SBControlCenterSeparatorView) class]){
      view.frame = CGRectMake(view.frame.origin.x,view.frame.origin.y,view.frame.size.width-100,view.frame.size.height);
    }
  }
}
}
- (void)dealloc {
<<<<<<< HEAD
  [CSSection release];
  CSSection = nil;
  %orig;
}
%end




//IOS 7**********************
%hook SBAppSliderController
%new
+ (id)sharedController {
  return [(SBUIController *)[%c(SBUIController) sharedInstance] _appSliderController];
}
%end

%end


=======
  [CSContainer release];
  CSContainer = nil;
  [CSSeparator release];
  CSSeparator = nil;
  %orig;
}
%end
%end
>>>>>>> cb7d7214b8270405dd160e74854fea27d457ef3e
%ctor {
  if (enable()) {
    %init(CSwitcher);
  }
}
