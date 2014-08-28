//
//  StudentLessonController.h
//  YourYoga
//
//  Created by john on 8/26/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Activities.h"


@interface StudentLessonController : UITableViewController

@property (nonatomic, strong)Activities* session;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startLessonButton;


@end
