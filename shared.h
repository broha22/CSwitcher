@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end
@interface SBAppSwitcherModel : NSObject
+ (id)sharedInstance;
- (void)removeDisplayItem:(id)arg1 ;
- (void)remove:(id)arg1;
- (id)identifiers;
- (id)snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary;
@end
@interface SBControlCenterSectionViewController : UIViewController
@end
@interface SBCCQuickLaunchSectionController : UIViewController
@end
@interface SBControlCenterSectionView : UIView
@property (assign,nonatomic) UIView *leftSection;               //@synthesize leftSection=_leftSection - In the implementation block
@end
@interface SBControlCenterContentView : UIView
@property(retain, nonatomic) SBCCQuickLaunchSectionController *quickLaunchSection; // @synthesize quickLaunchSection=_quickLaunchSection;
@property(retain, nonatomic) SBControlCenterSectionViewController *airplaySection; // @synthesize airplaySection=_airplaySection;
@property(retain, nonatomic) SBControlCenterSectionViewController *mediaControlsSection; // @synthesize mediaControlsSection=_mediaControlsSection;
@property(retain, nonatomic) SBControlCenterSectionViewController *brightnessSection;
@end
@interface SBControlCenterSeparatorView : UIView
@end
@interface SBIconModel : NSObject
- (id)expectedIconForDisplayIdentifier:(id)arg1;
@end

@interface SBIconController : NSObject
+ (SBIconController *)sharedInstance;
- (SBIconModel *)model;
@end

@interface SBIcon : NSObject
- (void)launchFromLocation:(int)arg1;
-(id)applicationBundleID;
@end

@interface SBIconView : UIView
- (id)initWithDefaultSize;
@property(retain, nonatomic) SBIcon *icon;
@property(assign, nonatomic) id delegate;
- (void)setHighlighted:(BOOL)arg1;
- (void)setIsEditing:(BOOL)arg1 animated:(BOOL)arg2;
- (void)_updateAdaptiveColors;
- (UIImageView *)_iconImageView;
- (void)setLabelHidden:(_Bool)arg1;
- (void)_applyIconAccessoryAlpha:(double)arg1;
@end

@interface SBAppSwitcherController : NSObject 
+ (id)sharedController;
- (id)_beginAppListAccess;
- (id)_snapshotViewForDisplayIdentifier:(id)arg1;
- (id)_generateCellViewForIndex:(unsigned long long)arg1;
- (void)_updateSnapshots;
- (id)_flattenedArrayOfDisplayItemsFromDisplayLayouts:(id)arg1;
@end

@interface SBAppSliderController : NSObject 
+ (id)sharedController;
- (id)_beginAppListAccess;
- (id)_snapshotViewForDisplayIdentifier:(id)arg1;
- (id)_generateCellViewForIndex:(unsigned long long)arg1;
- (void)_updateSnapshots;
@end

@interface SBUIController : NSObject
+ (id)sharedInstance;
- (id)_appSwitcherController;
- (id)_appSliderController;
- (void)activateApplicationAnimated:(id)arg1;
@end

@interface SBControlCenterController : NSObject
- (void)presentAnimated:(BOOL)arg1;
+ (id)sharedInstance;
@end
@interface UICSWindow : UIWindow
@end
@interface SBCCButtonLayoutView : UIView
@end
@interface SpringBoard : UIApplication
- (id)_accessibilityRunningApplications;
- (void)cancelMenuButtonRequests;
- (void)_handleMenuButtonEvent;
- (BOOL)isLocked;
- (long long)activeInterfaceOrientation;
- (UICSWindow *)CSWindow;
@end
@interface __NSArrayM : NSMutableArray
@end
@interface SBApplication : NSObject
- (id)bundle;
@end
@interface SBApplicationController : NSObject
+ (id)sharedInstance;
-(id)applicationWithBundleIdentifier:(id)arg1;
- (id)applicationWithDisplayIdentifier:(id)arg1;
@end
@interface SBAppSwitcherSnapshotView : UIView
- (UIImageView *)_snapshotImage;
- (struct CGSize)sizeThatFits:(struct CGSize)arg1;
@property (assign,nonatomic) long long orientation;                                      //@synthesize orientation=_orientation - In the implementation block
-(id)initWithDisplayItem:(id)arg1 application:(id)arg2 orientation:(long long)arg3 async:(bool)arg4 withQueue:(id)arg5 statusBarCache:(id)arg6 ;
@end

@interface SBAppSliderSnapshotView : UIView
- (UIImageView *)_snapshotImage;
@property(nonatomic) long long orientation; // @synthesize orientation=_orientation;
- (struct CGSize)sizeThatFits:(struct CGSize)arg1;
- (id)initWithApplication:(id)app orientation:(int)orientation async:(BOOL)arg withQueue:(id)queue statusBarCache:(id)arg2;
@end

@interface SBAppSwitcherPageView : UIView
- (id)initWithFrame:(struct CGRect)arg1;
- (void)setView:(id)arg1 animated:(_Bool)arg2;
@end
@interface BKSCFBundle : NSObject
- (id)executablePath;
@end

@interface SBCloseBoxView : UIButton
@end
@interface SBDisplayLayout : NSObject
-(id)description;
-(id)uniqueStringRepresentation;
@end
@interface SBDisplayItem : NSObject
@property (nonatomic,readonly) NSString * type;                           //@synthesize type=_type - In the implementation block
+(id)displayItemWithType:(NSString*)arg1 displayIdentifier:(id)arg2 ;

@end