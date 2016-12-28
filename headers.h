@interface CSwitcherFlowLayout : UICollectionViewFlowLayout
@end

@interface SBControlCenterSectionViewController : UIViewController
@end

@interface CSwitcherController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong, setter=setRecentApps:) NSMutableArray *recentApplications;
@property CGFloat controlHeight;
+(CSwitcherController *)sharedInstance;
- (CGFloat)newHeightFromOld:(CGFloat)oldHeight orientation:(NSInteger)orientation;
- (void)setRecentApps:(NSMutableArray *)arg;
- (id)displayItemForCell:(id)cell;
@end

@interface SBAppSwitcherModel : NSObject
+(SBAppSwitcherModel *) sharedInstance;
-(id)snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary;
//iOS 9
- (id)mainSwitcherDisplayItems;
-(void)remove:(id)arg1;
@end

@interface SBAppSwitcherController
+(SBAppSwitcherController *)sharedController;
@end

@interface SBAppSwitcherSnapshotView : UIView
-(id)initWithDisplayItem:(id)arg1 application:(id)arg2 orientation:(long long)arg3 async:(BOOL)arg4 withQueue:(id)arg5 statusBarCache:(id)arg6 ;
@end

@interface SBApplicationController : NSObject
+(SBApplicationController *)sharedInstanceIfExists;
-(id)applicationWithBundleIdentifier:(id)arg1 ;
@end

@interface SBApplication : NSObject
@end

@interface SBIcon : NSObject
@end

@interface SBApplicationIcon : SBIcon
-(id)initWithApplication:(id)arg1 ;
@end

@interface SBIconView : UIView
@property (assign,nonatomic) id delegate;
@property (nonatomic,retain) SBIcon * icon;
-(id)initWithDefaultSize;
+ (CGSize)defaultIconSize;
@end

@interface SpringBoard
-(long long)activeInterfaceOrientation;
@end

@interface SBControlCenterContentView
-(void)_addSectionController:(id)arg1 ;
- (double)contentHeightForOrientation:(long long)arg1;
@end

@interface SBDisplayItem
@property (nonatomic, assign) NSString *displayIdentifier;
@end

@interface CSwitcherCell : UICollectionViewCell <UIScrollViewDelegate>
@property (nonatomic, strong) SBIconView *iconView;
@property (nonatomic, strong) SBAppSwitcherSnapshotView *snapshot;
@property (nonatomic, strong) UIScrollView *scrollview;
@end

