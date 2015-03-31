<<<<<<< HEAD
static NSString *domainString = @"com.broganminer.cswitcher~prefs";

static BOOL fivecon(void) {
    NSNumber *fivecon = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"fivecon" inDomain:domainString];
    return (fivecon)? [fivecon boolValue]:YES;
}

static BOOL snaps(void) {
    NSNumber *snaps = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"snaps" inDomain:domainString];
    return (snaps)? [snaps boolValue]:YES;
}

static BOOL paging(void) {
    NSNumber *paging = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"paging" inDomain:domainString];
    return (paging)? [paging boolValue]:YES;
}



=======
#import "CSView.h"
static NSString *const filePath = @"/var/mobile/Library/Preferences/com.broganminer.cswitcher~prefs.plist";
static NSDictionary *prefs = [[[NSDictionary alloc] initWithContentsOfFile:filePath] autorelease];

static BOOL fivecon(void) {
    bool fivecon = (prefs)? [prefs [@"fivecon"] boolValue] : NO;
    return fivecon;
}

static BOOL snaps(void) {
    bool snaps = (prefs)? [prefs [@"snaps"] boolValue] : NO;
    return snaps;
}

static BOOL paging(void) {
    bool paging = (prefs)? [prefs [@"paging"] boolValue] : YES;
    return paging;
}
>>>>>>> cb7d7214b8270405dd160e74854fea27d457ef3e
