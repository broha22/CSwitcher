#import "shared.h"
#import "CSView-New.h"
#import "CSIconDelegate.h"
#import "prefs.h"
#import "CSContainer.h"
#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static int iconCount() {
    if (fivecon()) {
      return 5;
    }
    else {
      return 4;
    }
}

static float calcX (int i) {
    int spacing = (DEVICE_WIDTH - (60 * iconCount()))/(iconCount()+1);
    if (paging()) {
      int page = floor((i-1)/iconCount())*DEVICE_WIDTH;
      int expectedOutcome = (iconCount()*spacing) + (60 * iconCount());
      float extra = (DEVICE_WIDTH - expectedOutcome);
      if (i%iconCount()== 1){
	return extra + page;
      }
      else {
	return extra + page + (((i-1)%iconCount()) * spacing) + (((i-1)%iconCount()) * 60);
      }
    }
     else {
	return (spacing * i) + (60 * (i - 1)); 
     }
}
static CSView *sharedCSView = nil;
static CSIconDelegate *sharedIconDelegate = [[CSIconDelegate alloc] init];
@implementation CSView

+ (CSView *)sharedView {
 if (sharedCSView == nil){
    sharedCSView = [[super alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,98)];
    sharedCSView.bounces = YES;
    sharedCSView.pagingEnabled = paging();
    sharedCSView.showsHorizontalScrollIndicator = NO;
    sharedCSView.showsVerticalScrollIndicator = NO;
    sharedCSView.clipsToBounds = YES;
    }
   return sharedCSView;
}

- (void)createCSContainersWithIDS:(NSMutableArray *)IDS {
_containers = [[NSMutableArray alloc] init];

  for (NSString *ID in IDS) {
    SBIcon *icon = [(SBIconModel *)[[%c(SBIconController) sharedInstance] model] expectedIconForDisplayIdentifier:ID];
    SBAppSwitcherSnapshotView *snapView8;
    SBAppSliderSnapshotView *snapView7;
    if (snaps() && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
      snapView8 = [[%c(SBAppSwitcherSnapshotView) alloc] initWithDisplayItem:nil application:[[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:ID] orientation:[(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] async:NO withQueue:MSHookIvar<NSObject<OS_dispatch_queue> *>([%c(SBAppSwitcherController) sharedController], "_snapshotQueue") statusBarCache:nil];
     }
    else if (snaps() && !SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
      snapView7 = [[%c(SBAppSliderSnapshotView) alloc] initWithApplication:[[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:ID] orientation:[(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] async:NO withQueue:MSHookIvar<NSObject<OS_dispatch_queue> *>([%c(SBAppSliderController) sharedController], "_snapshotQueue") statusBarCache:nil];
    }
    else {
      snapView8 = nil;
      snapView7 = nil;
     }
     
     CSContainer *container;
     if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
      container = [[CSContainer alloc] initWithIcon:icon snapshot:snapView8];
     }
     else {
      container = [[CSContainer alloc] initWithIcon:icon snapshot:snapView7];
     }
     container.id = ID;
     [_containers addObject:container];
     [self addSubview:container];
    }
  [self positionContainers];
}

- (void)removeContainer:(CSContainer *)container {
  SBApplication *app;
  if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
    app = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:container.id];
  }
  else {
    app = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:container.id];
  }
  system([[NSString stringWithFormat:@"killall %@", [[[app bundle] executablePath] lastPathComponent]] UTF8String]);
   for (CSContainer *view in _containers){
    if ([_containers indexOfObject:container] < [_containers indexOfObject:view]) {
      [UIView animateWithDuration:0.25f delay:0.05f options:UIViewAnimationCurveEaseOut
                             animations:^{
			      if (container.contentSize.height > 62) {
				  view.frame = CGRectMake(calcX([_containers indexOfObject:view]),0,62,98);
			      }
			      if (container.contentSize.width > 62) {
				  view.frame = CGRectMake(0,calcX([_containers indexOfObject:view]),98,62);
			      }
                             }
                             completion:^(BOOL finnished){
			      	[self cleanUpKill:container];
                             }];
    }
   }
  [self adjustContentSize];
}

- (void)cleanUpKill:(CSContainer *)container {
  [_containers removeObject:container];
  if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
    [[%c(SBAppSwitcherModel) sharedInstance] removeDisplayItem:[%c(SBDisplayItem) displayItemWithType:@"App" displayIdentifier:container.id]];
  }
  else {
    [[%c(SBAppSwitcherModel) sharedInstance] remove:container.id];
  }
  // [container release];
 //wtf
}

- (void)moveContainerToFront:(CSContainer *)container {
  [_containers removeObject:container];
  [_containers insertObject:container atIndex:0];
}

- (NSMutableArray *)containers {
  return _containers;
}

- (void)tappedContainer:(UIGestureRecognizer *)recognizer {
    [self activateAppWithContainer:((CSContainer *)recognizer.view)];
}

- (void)activateAppWithContainer:(CSContainer *)container {
  [container launchApp];
}

- (void)positionContainers {
  int currentOrientation = [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation];
  if (currentOrientation == 1 || currentOrientation == 2) {
    for (CSContainer *container in _containers) {
      container.frame = CGRectMake(calcX([_containers indexOfObject:container]+1),0,62,98);
      [container adjustIconToOrientation];
    }      
    self.frame = CGRectMake(0,0,DEVICE_WIDTH,98);

  }
  else {
    for (CSContainer *container in _containers) {
      container.frame = CGRectMake(0,calcX([_containers indexOfObject:container]+1),98,62);
      [container adjustIconToOrientation];
    }      
    self.frame = CGRectMake(0,0,98,DEVICE_WIDTH);

  }
  [self adjustContentSize];
}

- (void)adjustContentSize {
  if (paging()){
   if (((CSContainer *)[_containers firstObject]).contentSize.height > 62) {
	self.contentSize = CGSizeMake((int)(([_containers count]+iconCount()-1)/iconCount()) * DEVICE_WIDTH,98);
   }
   if (((CSContainer *)[_containers firstObject]).contentSize.width > 62) {
	self.contentSize = CGSizeMake(98,(int)(([_containers count]+iconCount()-1)/iconCount()) * DEVICE_WIDTH);
   }
  }
  if (!paging()){
      float inBetween = (DEVICE_WIDTH - (iconCount() * 60))/(iconCount() + 1);
   if (((CSContainer *)[_containers firstObject]).contentSize.height > 62) {
	self.contentSize = CGSizeMake((60 * [_containers count])+(([_containers count]-1) * inBetween),98);
   }
   if (((CSContainer *)[_containers firstObject]).contentSize.width > 62) {
	self.contentSize = CGSizeMake(98,(60 * [_containers count])+(([_containers count]-1) * inBetween));
   }
  }
}

- (id)iconDelegate {
  return sharedIconDelegate;
}

- (void)moveAppToFront:(id)app {
  NSString *appID;
  if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
    appID = [[((SBDisplayLayout *)app) uniqueStringRepresentation] stringByReplacingOccurrencesOfString:@"0-App-" withString:@""];
  }
  else {
    appID = app;
  }
  NSArray *_containersCopy = [_containers copy];
  BOOL createNewContainer = NO;
  for (CSContainer *container in _containersCopy) {
    if ([appID isEqualToString:container.id]) {
      [self moveContainerToFront:container];
      createNewContainer = YES;
    }
  }
  [_containersCopy release];
  
  if (!createNewContainer) {
    SBIcon *icon = [(SBIconModel *)[[%c(SBIconController) sharedInstance] model] expectedIconForDisplayIdentifier:appID];
    SBAppSwitcherSnapshotView *snapView8;
    SBAppSliderSnapshotView *snapView7;
    if (snaps() && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
      snapView8 = [[%c(SBAppSwitcherSnapshotView) alloc] initWithDisplayItem:nil application:[[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:appID] orientation:[(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] async:NO withQueue:MSHookIvar<NSObject<OS_dispatch_queue> *>([%c(SBAppSwitcherController) sharedController], "_snapshotQueue") statusBarCache:nil];
     }
    else if (snaps() && !SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
      snapView7 = [[%c(SBAppSliderSnapshotView) alloc] initWithApplication:[[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:appID] orientation:[(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] async:NO withQueue:MSHookIvar<NSObject<OS_dispatch_queue> *>([%c(SBAppSliderController) sharedController], "_snapshotQueue") statusBarCache:nil];
    }
    else {
      snapView8 = nil;
      snapView7 = nil;
     }
     
     CSContainer *container;
     if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
      container = [[CSContainer alloc] initWithIcon:icon snapshot:snapView8];
     }
     else {
      container = [[CSContainer alloc] initWithIcon:icon snapshot:snapView7];
     }
     container.id = appID;
     [_containers insertObject:container atIndex:0];
     [self addSubview:container];
  }
    
}/*
- (BOOL)snaps{
  return snaps();
}
- (BOOL)paging {
  return paging();
}
- (int)iconCount {
  return iconCount();
}*/
@end