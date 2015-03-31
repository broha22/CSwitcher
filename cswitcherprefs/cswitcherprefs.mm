#import <Preferences/Preferences.h>
#import <Social/Social.h>
@interface PSSwitchTableCell : PSControlTableCell {
    UIActivityIndicatorView *_activityIndicator;
}

@property BOOL loading;

- (BOOL)canReload;
- (id)controlValue;
- (void)dealloc;
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3;
- (void)layoutSubviews;
- (BOOL)loading;
- (id)newControl;
- (void)prepareForReuse;
- (void)refreshCellContentsWithSpecifier:(id)arg1;
- (void)reloadWithSpecifier:(id)arg1 animated:(BOOL)arg2;
- (void)setCellEnabled:(BOOL)arg1;
- (void)setLoading:(BOOL)arg1;
- (void)setValue:(id)arg1;

@end
@interface cswitcherprefsListController: PSListController {
UIColor *oldTintColor;
}
@end
@implementation cswitcherprefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"cswitcherprefs" target:self] retain];
	}
	return _specifiers;
}
- (id)navigationItem {
    UINavigationItem *item = [super navigationItem];
    UIButton *buttonTwitter = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonTwitter setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/cswitcherprefs.bundle/heart.png"] forState:UIControlStateNormal];
    buttonTwitter.frame = CGRectMake(0,0,35,35);
    UIBarButtonItem *heart = [[[UIBarButtonItem alloc] initWithCustomView:buttonTwitter] autorelease];
    [buttonTwitter addTarget:self action:@selector(tweeter) forControlEvents:UIControlEventTouchUpInside];
    item.rightBarButtonItem = heart;
    return item;
}
- (void)tweeter {
    SLComposeViewController *tweeter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweeter setInitialText:@"Check out CSwitcher. A tweak by @broganminerdev which moves the App Switcher into the Control Center."];
    [(UIViewController *)self presentViewController:tweeter animated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor colorWithRed:146.f/255.f green:34.f/255.f blue:1 alpha:1];
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] keyWindow].tintColor = nil;

}
- (void)apply {
  system("killall SpringBoard");
}
- (void)donate {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=LFHXZJZWNJBWQ&lc=US&item_name=Brogan%20Miner&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted"]];

}
@end
@interface mainHeaderCS : PSTableCell {
    UIImageView *imageView;
    UIImage *image;
}
@end
@implementation mainHeaderCS
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3{
    self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
    if (self) {
        image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/cswitcherprefs.bundle/CSwitcher-label.png"];
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0,0,320,100);
        [self addSubview:imageView];

    }
    return self;
}
- (void)dealloc {
    [imageView release];
    imageView = nil;
    [super dealloc];
}
@end

@interface purpleswitch : PSSwitchTableCell {
}
@end
@implementation purpleswitch
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3{
    self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
    if (self) {
    }
    return self;
}
- (void)layoutSubviews {
  [super layoutSubviews];
  ((UITableViewCell *)self).accessoryView.tintColor = [UIColor colorWithRed:146.f/255.f green:34.f/255.f blue:1 alpha:1];
  ((UISwitch *)((UITableViewCell *)self).accessoryView).onTintColor = [UIColor colorWithRed:146.f/255.f green:34.f/255.f blue:1 alpha:1];

}
@end

@interface purplebutton : PSTableCell {
}
@end
@implementation purplebutton
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3{
    self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
    if (self) {
    }
    return self;
}
- (void)layoutSubviews {
     [super layoutSubviews];
     ((UITableViewCell *)self).textLabel.textColor = [UIColor colorWithRed:146.f/255.f green:34.f/255.f blue:1 alpha:1];
  }

@end
// vim:ft=objc
