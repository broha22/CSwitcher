#import "headers.h"
#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
/*
ios 9 only, old code commented out
*/

%hook SBAppSwitcherModel
-(void)appsRemoved:(id)arg1 added:(id)arg2 {
	%orig;
	[CSwitcherController sharedInstance].recentApplications = [self mainSwitcherDisplayItems];
	//[CSwitcherController sharedInstance].recentApplications = [[[self snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary] mutableCopy] retain];
}

-(void)remove:(id)arg1 {
	%orig;
	[CSwitcherController sharedInstance].recentApplications = [self mainSwitcherDisplayItems];
	//[CSwitcherController sharedInstance].recentApplications = [[[self snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary] mutableCopy] retain];
}

-(void)removeDisplayItem:(id)arg1 {
	%orig;
	[CSwitcherController sharedInstance].recentApplications = [self mainSwitcherDisplayItems];
	//[CSwitcherController sharedInstance].recentApplications = [[[self snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary] mutableCopy] retain];
}

-(void)addToFront:(id)arg1 {
	%orig;
	[CSwitcherController sharedInstance].recentApplications = [self mainSwitcherDisplayItems];
	//[CSwitcherController sharedInstance].recentApplications = [[[self snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary] mutableCopy] retain];
}
%end

@implementation CSwitcherCell
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self) {
		[self addSubview: self.iconView];
		//self.backgroundColor = [UIColor redColor];
	}
	return self;
}
- (void)prepareForReuse {
    [super prepareForReuse];
    for (UIView *view in self.subviews) {
    	[view removeFromSuperview];
    }
}
- (void)layoutSubviews {
	[super layoutSubviews];
	[self addSubview: self.iconView];
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
	_recentApplications = [arg retain];
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
	SBIconView *iconView = [%c(SBIconView) new];
	iconView.frame = CGRectMake(0,0,[%c(SBIconView) defaultIconSize].width,[%c(SBIconView) defaultIconSize].height);
	iconView.icon = appIcon;
	iconView.delegate = [%c(SBIconController) sharedInstance];
	cell.iconView = iconView;

	//SBAppSwitcherSnapshotView *snapshot = [[%c(SBAppSwitcherSnapshotView) alloc] initWithDisplayItem:nil application:app orientation:[(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] async:NO withQueue:MSHookIvar<NSObject *>([%c(SBAppSwitcherController) sharedController], "_snapshotQueue") statusBarCache:nil];
	//cell.snapshot = snapshot;

	return cell;
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

%ctor {
	NSLog(@"CSwitcher loaded");
}