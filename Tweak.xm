#import "headers.h"
#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define ICON_COUNT 4
#define ICON_INSET 10
#define PAGING_ENABLED true
#define SNAPSHOTS_ENABLED true
#define REPLACE_QL false
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
@implementation CSwitcherFlowLayout
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
	NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
	if (PAGING_ENABLED) {
		CGFloat defaultsize = [%c(SBIconView) defaultIconSize].width;
		for (UICollectionViewLayoutAttributes *attr in attributes) {
			NSInteger index = [attributes indexOfObject:attr];
			CGFloat evenSpace = (((float)(DEVICE_WIDTH-(ICON_INSET*2))/(float)ICON_COUNT));
			NSInteger secNum = ((int)index/(int)ICON_COUNT);
			CGFloat newX = evenSpace*(index%ICON_COUNT)+ICON_INSET+(DEVICE_WIDTH*secNum)+(evenSpace-defaultsize)/2;
			CGRect newFrame = CGRectMake(newX,attr.frame.origin.y,attr.frame.size.width,attr.frame.size.height);
			if(SNAPSHOTS_ENABLED)newFrame.origin.y -= 15;
			attr.frame = newFrame;
		}
	}
	return attributes;
}
- (CGSize)collectionViewContentSize {
	CGSize normal = [super collectionViewContentSize];
	return (PAGING_ENABLED)?CGSizeMake(ceil((float)[[CSwitcherController sharedInstance].recentApplications count]/(float)ICON_COUNT)*DEVICE_WIDTH,normal.height):normal;
}
@end
@implementation CSwitcherCell
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self) {
		self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
		self.scrollview.contentSize = CGSizeMake(frame.size.width,frame.size.height+50);
		self.scrollview.clipsToBounds = false;
		self.scrollview.showsVerticalScrollIndicator = false;
		self.scrollview.delegate = self;
		self.snapshotView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,DEVICE_HEIGHT*(frame.size.width/DEVICE_WIDTH))];
		self.snapshotView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
		UITapGestureRecognizer *tapLaunch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedContainer:)];
		[self addGestureRecognizer:tapLaunch];
	}
	return self;
}
- (void)prepareForReuse {
    [super prepareForReuse];
    for (UIView *view in self.scrollview.subviews) {
    	[view removeFromSuperview];
    }
    [self.scrollview removeFromSuperview];
    self.snapshotView.image = nil;
    [self.snapshotView removeFromSuperview];
    self.scrollview.contentOffset = CGPointMake(0,0);
}
- (void)layoutSubviews {
	[super layoutSubviews];
	[self addSubview:self.scrollview];
	[self.scrollview addSubview: self.iconView];
	if (SNAPSHOTS_ENABLED) {
		((UIView *)[self.iconView _iconImageView]).layer.transform = CATransform3DMakeScale(0.6,0.6,0.6);
		CGFloat yChange = 0.8*[%c(SBIconView) defaultIconSize].height;
		((UIView *)[self.iconView _iconImageView]).layer.transform = CATransform3DTranslate(((UIView *)[self.iconView _iconImageView]).layer.transform,0,yChange,0);
		[self.iconView setLabelHidden:true];
		[MSHookIvar<UIView *>(self.iconView, "_accessoryView") removeFromSuperview];
		[self.scrollview insertSubview:self.snapshotView atIndex:0];
		self.snapshotView.image = self.snapshot;
	}
}
- (void)tappedContainer:(UIView *)container {
	SBApplication *app = [(SBApplicationController *)[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:[self.iconView.icon applicationBundleID]];
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:[app bundleIdentifier] suspended:NO];
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
	if (SNAPSHOTS_ENABLED)oldHeight += 20;
	if (!REPLACE_QL)oldHeight += 100;
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
    CGRect contentViewFrame = CGRectMake(0,self.controlHeight-100,DEVICE_WIDTH,98);
    if (SNAPSHOTS_ENABLED) {
    	contentViewFrame.origin.y -= 20;
    	contentViewFrame.size.height += 20;
    }
    self.view.frame = contentViewFrame;
    self.recentApplications = [(SBAppSwitcherModel *)[%c(SBAppSwitcherModel) sharedInstance] mainSwitcherDisplayItems];
    
    CSwitcherFlowLayout *flowLayout = [[CSwitcherFlowLayout alloc] init];
    [flowLayout setItemSize:[%c(SBIconView) defaultIconSize]];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = UIColor.clearColor;
    [self.collectionView registerClass:[CSwitcherCell class] forCellWithReuseIdentifier:@"CellView"];
    self.collectionView.showsHorizontalScrollIndicator = false;
    if(PAGING_ENABLED)self.collectionView.pagingEnabled = true;
    //flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 10, 5);

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
	NSString *identifier = ((SBDisplayItem *)[self.recentApplications objectAtIndex:indexPath.row]).displayIdentifier;

	SBApplicationController *appController = [%c(SBApplicationController) sharedInstanceIfExists];
	SBApplication *app = [appController applicationWithBundleIdentifier:identifier];
	SBApplicationIcon *appIcon = [[%c(SBApplicationIcon) alloc] initWithApplication:app];
	SBIconView *iconView = [[%c(SBIconView) alloc] initWithContentType:0];
	iconView.icon = appIcon;
	iconView.delegate = [%c(SBIconController) sharedInstance];

	iconView.userInteractionEnabled = false;
	cell.iconView = iconView;

	//iOS 9 has made it way too difficult to get app previews
	@try {
		NSException *generalErrorException = [NSException exceptionWithName:@"generalErrorException" reason:@"Snap shot container path was empty or not found" userInfo:nil];
		NSString *snapShotContainerPath = [[app _snapshotManifest] containerPath];
		NSError *errorFD;
		NSArray *firstDir = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:snapShotContainerPath error:&errorFD];
		if (errorFD || !firstDir)@throw generalErrorException;

		NSString *correctSnapShotContainerPath = [snapShotContainerPath stringByAppendingString:[@"/" stringByAppendingString:firstDir[0]]];
		NSError *errorSD;
		NSArray *allSnapshots = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:correctSnapShotContainerPath error:&errorSD];
		if (errorSD || !allSnapshots)@throw generalErrorException;

		NSDate *newestDate = nil;
		NSString *newestSnapshotPath = nil;
		for (NSString *fileName in allSnapshots) {
			if (![fileName isEqual:@"downscaled"]) {
				NSString *fullSnapPath = [correctSnapShotContainerPath stringByAppendingString:[@"/" stringByAppendingString:fileName]];
				NSDictionary *fileAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:fullSnapPath error:nil];
				NSDate *fileCreationDate = (NSDate *)[fileAttr objectForKey:NSFileCreationDate];
				if (newestDate == nil || [fileCreationDate compare:newestDate] == NSOrderedDescending) {
					newestDate = fileCreationDate;
					newestSnapshotPath = fullSnapPath;
				}
			}
		}
		cell.snapshot = [[UIImage alloc] initWithContentsOfFile:newestSnapshotPath];
	}
	@catch(NSException *e) {
		NSLog(@"CSwitcher - Failed to create cell snapshot %@",e);
	}	

	return cell;
}
- (id)displayItemForCell:(id)cell {
	NSIndexPath *path = [self.collectionView indexPathForCell:cell];
	return [self.recentApplications objectAtIndex:path.row];
}
@end


%hook SBControlCenterContentView
-(void)layoutSubviews {
	%orig;
	[self _addSectionController:[CSwitcherController sharedInstance]];
	UIView *QLView = ((UIViewController *)[self quickLaunchSection]).view;
	QLView.frame = CGRectMake(QLView.frame.origin.x,QLView.frame.origin.y,QLView.frame.size.width,QLView.frame.size.height-[CSwitcherController sharedInstance].view.frame.size.height);
	
}
-(void)_addSectionController:(id)arg1 {
	if ([arg1 isKindOfClass:[%c(SBCCQuickLaunchSectionController) class]] && REPLACE_QL) {
		return;		
	}
	%orig;
}
- (double)contentHeightForOrientation:(long long)arg1 {
	return [[CSwitcherController sharedInstance] newHeightFromOld:%orig orientation:arg1];
}
%end
%ctor {
	NSLog(@"CSwitcher loaded");
}