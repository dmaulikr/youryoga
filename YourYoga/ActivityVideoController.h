//
//  ActivityVideoController.h
//  YourYoga
//
//  Created by john on 8/29/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "VideoUrlCell.h"
#import "Activity.h"

@interface ActivityVideoController : UITableViewController

@property (nonatomic, strong)Activity* activity;

@property (weak, nonatomic) IBOutlet VideoUrlCell *videoUrlCell;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
