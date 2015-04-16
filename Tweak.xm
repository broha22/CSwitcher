#import "headers.h"

%hook SBAppSwitcherModel
-(void)appsRemoved:(id)arg1 added:(id)arg2 {
	%orig;
	[CSwitcherController sharedInstance].recentApplications = [[[self snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary] mutableCopy] retain];
}

-(void)remove:(id)arg1 {
	%orig;
	[CSwitcherController sharedInstance].recentApplications = [[[self snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary] mutableCopy] retain];
}

-(void)removeDisplayItem:(id)arg1 {
	%orig;
	[CSwitcherController sharedInstance].recentApplications = [[[self snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary] mutableCopy] retain];
}

-(void)addToFront:(id)arg1 {
	%orig;
	[CSwitcherController sharedInstance].recentApplications = [[[self snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary] mutableCopy] retain];
}
%end




@implementation CSwitcherCell
-(id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self) {
		// setup view with icon and snapshot
	}
	return self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recentApplications = [[[(SBAppSwitcherModel *)[%c(SBAppSwitcherModel) sharedInstance] snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary] mutableCopy] retain];
    [self.collectionView registerClass:[CSwitcherCell class] forCellWithReuseIdentifier:@"CellView"];
    UICollectionViewFlowLayout *flowLayout = [[%c(CSwitcherFlowLayout) alloc] init];
    [flowLayout setItemSize:CGSizeMake(200, 200)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.collectionView setCollectionViewLayout:flowLayout];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.recentApplications count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CSwitcherCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellView" forIndexPath:indexPath];
	
	NSString *identifier = [self.recentApplications objectAtIndex:indexPath.section];

	SBApplicationController *appController = [%c(SBApplicationController) sharedInstanceIfExists];
	SBApplication *app = [appController applicationWithBundleIdentifier:identifier];
	SBApplicationIcon *appIcon = [[%c(SBApplicationIcon) alloc] initWithApplication:app];
	SBIconView *iconView = [[%c(SBIconView) alloc] initWithDefaultSize];
	iconView.icon = appIcon;
	iconView.delegate = [%c(SBIconController) sharedInstance];
	cell.iconView = iconView;

	SBAppSwitcherSnapshotView *snapshot = [[%c(SBAppSwitcherSnapshotView) alloc] initWithDisplayItem:nil application:app orientation:[(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] activeInterfaceOrientation] async:NO withQueue:MSHookIvar<NSObject *>([%c(SBAppSwitcherController) sharedController], "_snapshotQueue") statusBarCache:nil];
	cell.snapshot = snapshot;

	return cell;
}

@end


%hook SBControlCenterContentView
-(void)layoutSubviews {
	[self _addSectionController:[CSwitcherController sharedInstance]];
	%orig;
}
-(void)_addSectionController:(id)arg1 {
	%log;
	%orig;
}
%end














