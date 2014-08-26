//
//  ActivityManager.h
//  YourYoga
//
//  Created by john on 8/17/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Activity.h"
#import "Activities.h"

static NSString* NM_ActivitiesHaveBeenUpdated = @"SessionsHaveBeenUpdated";

@interface SessionsManager : NSObject
{
    NSMutableArray* _sessions;
}

@property (atomic, strong) NSMutableArray* sessions;

+(SessionsManager*)defaultInstance;

-(void)load;
-(void)save;


@end
