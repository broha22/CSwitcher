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
