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
}
%end

%hook SBControlCenterController
- (void)_endPresentation {
  %orig;
  [CSView sharedView].contentOffset = CGPointMake(0,0);
}
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
  }
  return CCHeight;
}
%end

%hook SBControlCenterContentView
- (void)layoutSubviews {
  %orig;
  int currentOrientation = [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation];
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
  for (UIView *view in self.subviews) {
    if ([view class] == [%c(SBControlCenterSeparatorView) class]){
      view.frame = CGRectMake(view.frame.origin.x,view.frame.origin.y,view.frame.size.width-100,view.frame.size.height);
    }
  }
}
}
- (void)dealloc {
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


%ctor {
  if (enable()) {
    %init(CSwitcher);
  }
}
