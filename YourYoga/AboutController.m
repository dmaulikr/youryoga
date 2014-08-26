//
//  AboutController.m
//  YourYoga
//
//  Created by john on 8/20/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *appVersion;

@end

@implementation AboutController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


-(void)loadBuildInfo
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *label = [NSString stringWithFormat:@"%@ v%@ (build %@)", name, version, build];
    _appVersion.textLabel.text = label;
}


@end
