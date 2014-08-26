//
//  EncourageController.m
//  YourYoga
//
//  Created by john on 8/18/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "EncourageController.h"
#import "Utilities.h"

@interface EncourageController ()
@property (weak, nonatomic) IBOutlet UIWebView *blogView;

@end

//
// Static TableView using UIWebView to display a webpage
//

@implementation EncourageController

- (void)viewDidLoad {
    [super viewDidLoad];

    @try {
        NSURL* url = [NSURL URLWithString:@"http://awakenedyoga83.wordpress.com/"];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        
        [self.blogView loadRequest:request];
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
}

#pragma mark - Table view data source


@end
