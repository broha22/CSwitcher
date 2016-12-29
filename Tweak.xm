#import "headers.h"
#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
/*
ios 9 only, old code commented out
*/

%hook SBAppSwitcherModel
-(void)appsRemoved:(id)arg1 added:(id)arg2 {
	%orig;
	[CSwitcherController sharedInstance].recentApplications = [self mainSwitcherDisplayItems];
}

-(void)remove:(id)arg1 {
	%orig;
	[CSwitcherController sharedInstance].recentApplications = [self mainSwitcherDisplayItems];
}

-(void)removeDisplayItem:(id)arg1 {
	%orig;
	[CSwitcherController sharedInstance].recentApplications = [self mainSwitcherDisplayItems];
}

-(void)addToFront:(id)arg1 {
	%orig;
	[CSwitcherController sharedInstance].recentApplications = [self mainSwitcherDisplayItems];
}
- (void)addToFront:(id)arg1 role:(NSInteger)arg2 {
	%orig;
	[CSwitcherController sharedInstance].recentApplications = [self mainSwitcherDisplayItems];
}
%end

@implementation CSwitcherCell
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self) {
		self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
		self.scrollview.contentSize = CGSizeMake(frame.size.width,frame.size.height+50);
		self.scrollview.clipsToBounds = false;
		self.scrollview.showsVerticalScrollIndicator = false;
		self.scrollview.delegate = self;
	}
	return self;
}
- (void)prepareForReuse {
    [super prepareForReuse];
    for (UIView *view in self.scrollview.subviews) {
    	[view removeFromSuperview];
    }
    [self.scrollview removeFromSuperview];
    self.scrollview.contentOffset = CGPointMake(0,0);
}
- (void)layoutSubviews {
	[super layoutSubviews];
	[self addSubview:self.scrollview];
	[self.scrollview addSubview: self.iconView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y > 20) {
		UICollectionView *collectionView = ((CSwitcherController *)[%c(CSwitcherController) sharedInstance]).collectionView;
		NSIndexPath *path = [collectionView indexPathForCell:self];
		if (path) {
			[((CSwitcherController *)[%c(CSwitcherController) sharedInstance]).recentApplications removeObject:[[%c(CSwitcherController) sharedInstance] displayItemForCell:self]];
			[collectionView deleteItemsAtIndexPaths:@[path]];
			NSMutableArray *recentApps = MSHookIvar<NSMutableArray *>([%c(SBAppSwitcherModel) sharedInstance], "_recentDisplayItems");
			[recentApps removeObjectAtIndex:path.row];

			[(SBAppSwitcherModel *)[%c(SBAppSwitcherModel) sharedInstance] _saveRecents];

		}
	}
	else {
		[UIView animateWithDuration:0.25f delay:0.1f options:UIViewAnimationCurveEaseIn
        		animations:^{
					scrollView.contentOffset = CGPointMake(0,0);
				}
		completion:nil];
	}
}
@end

@implementation CSwitcherController

+ (id)sharedInstance{
    static dispatch_once_t onceToken;
    static CSwitcherController *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [CSwitcherController new];
    });
    return sharedInstance;
}
- (CGFloat)newHeightFromOld:(CGFloat)oldHeight orientation:(NSInteger)orientation {
	self.controlHeight = oldHeight;
	return oldHeight;
}
- (void)setRecentApps:(NSMutableArray *)arg {
	_recentApplications = [arg mutableCopy];
	[self.collectionView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];    
    [self.collectionView release];
    self.view.frame = CGRectMake(0,self.controlHeight-100,DEVICE_WIDTH,98);
    self.recentApplications = [(SBAppSwitcherModel *)[%c(SBAppSwitcherModel) sharedInstance] mainSwitcherDisplayItems];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:[%c(SBIconView) defaultIconSize]];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = UIColor.clearColor;
    [self.collectionView registerClass:[CSwitcherCell class] forCellWithReuseIdentifier:@"CellView"];
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.pagingEnabled = true;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 2, 5);

    [self.view addSubview:self.collectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.recentApplications count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CSwitcherCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellView" forIndexPath:indexPath];
	NSLog(@"CSwitcher - %@",indexPath);
	NSString *identifier = ((SBDisplayItem *)[self.recentApplications objectAtIndex:indexPath.row]).displayIdentifier;

	SBApplicationController *appController = [%c(SBApplicationController) sharedInstanceIfExists];
	SBApplication *app = [appController applicationWithBundleIdentifier:identifier];
	SBApplicationIcon *appIcon = [[%c(SBApplicationIcon) alloc] initWithApplication:app];
	SBIconView *iconView = [[%c(SBIconView) alloc] initWithContentType:0];
	//iconView.frame = CGRectMake(0,0,[%c(SBIconView) defaultIconSize].width,[%c(SBIconView) defaultIconSize].height);
	//CGRect labelFrame = ((UIView *)[iconView labelView]).frame;
	//labelFrame.origin.y += [[iconView class] defaultIconImageSize].height;
	//((UIView *)[iconView labelView]).frame = labelFrame;
	iconView.icon = appIcon;
	iconView.delegate = [%c(SBIconController) sharedInstance];

	//Note I should change this at some point but for now it will work
	iconView.tag = 101;
	cell.iconView = iconView;

	//SBAppSwitcherSnapshotView *snapshot = [[%c(SBAppSwitcherSnapshotView) alloc] initWithDisplayItem:nil application:app orientation:[(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] async:NO withQueue:MSHookIvar<NSObject *>([%c(SBAppSwitcherController) sharedController], "_snapshotQueue") statusBarCache:nil];
	//cell.snapshot = snapshot;

	return cell;
}
- (id)displayItemForCell:(id)cell {
	NSIndexPath *path = [self.collectionView indexPathForCell:cell];
	return [self.recentApplications objectAtIndex:path.row];
}
@end


%hook SBControlCenterContentView
-(void)layoutSubviews {
	//[self contentHeightForOrientation:[[UIDevice currentDevice] orientation]];
	%orig;
	[self _addSectionController:[CSwitcherController sharedInstance]];
	
}
-(void)_addSectionController:(id)arg1 {
	if (![arg1 isKindOfClass:[%c(SBCCQuickLaunchSectionController) class]]) {
		%orig();
		
	}
	
}
- (double)contentHeightForOrientation:(long long)arg1 {
	return [[CSwitcherController sharedInstance] newHeightFromOld:%orig orientation:arg1];
}
%end

%hook SBIconController
- (void)iconTapped:(id)arg1 {
	SBIconView *iconView = arg1;
	if (iconView.tag == 101) {
			[iconView setHighlighted:NO];
			SBApplication *app = [(SBApplicationController *)[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:[iconView.icon applicationBundleID]];
			[[UIApplication sharedApplication] launchApplicationWithIdentifier:[app bundleIdentifier] suspended:NO];
	}
	else {
		%orig;
	}
}
%end

%ctor {
	NSLog(@"CSwitcher loaded");
}