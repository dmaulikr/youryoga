//
//  ProgressCell.h
//  YourYoga
//
//  Created by john on 8/26/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressCell : UITableViewCell

@property (nonatomic, strong)IBOutlet UIProgressView* progress;
@property (nonatomic, strong)IBOutlet UIProgressView* timer;

@end
