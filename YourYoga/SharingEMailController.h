//
//  SharingEMailController.h
//  YourYoga
//
//  Created by john on 8/28/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "SessionsManager.h"
#import "ExportFileInfo.h"

@interface SharingEMailController : UITableViewController


//@property (nonatomic, strong)SessionsManager* Manager;
//@property (nonatomic, strong)NSMutableArray* Selections;
@property (nonatomic, strong)ExportFileInfo* Export;

@end
