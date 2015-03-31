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



