#import "shared.h"
#import "CSContainer.h"
@interface CSView : UIScrollView {
  NSMutableArray *_containers;
}
+ (CSView *)sharedView;
- (void)createCSContainersWithIDS:(NSMutableArray *)IDS;
- (void)removeContainer:(CSContainer *)container;
- (void)cleanUpKill:(CSContainer *)container;
- (void)moveContainerToFront:(CSContainer *)container;
- (NSMutableArray *)containers;
- (void)tappedContainer:(UIGestureRecognizer *)recognizer;
- (void)activateAppWithContainer:(CSContainer *)container;
- (void)positionContainers;
- (void)adjustContentSize;
- (id)iconDelegate;
- (void)moveAppToFront:(NSString *)app;
/*
- (BOOL)snaps;
- (BOOL)paging;
- (int)iconCount;*/
@end



