//
//  Activities.m
//  YourYoga
//
//  Created by john on 8/26/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "Activity.h"
#import "Activities.h"
#import "ActivityStats.h"


static NSString* P_Name = @"activities.name";
static NSString* P_Activities = @"activities.items";

@implementation Activities



-(id)init
{
    self = [super init];
    if (self){
        _activities = [[NSMutableArray alloc]init];
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary*)d
{
    self = [self init];
    if (self){
        
        if (d){
            _name = [d objectForKey:P_Name];
            NSMutableArray* xload = [d objectForKey:P_Activities];
            if (xload){
                for(NSDictionary* d in xload){
                    Activity* a = [[Activity alloc]initWithDictionary:d];
                    [_activities addObject:a];
                }
            }
            
        }
        
    }
    return self;
}


+(ActivityStats*)summaryStats:(Activities*)activities
{
    NSInteger totalSeconds = 0;
    ActivityStats* stats = [[ActivityStats alloc]init];
    
    stats.totalTasks = activities.activities.count;
    
    for(int x = 0; x < activities.activities.count; ++x){
        Activity* a = [activities.activities objectAtIndex:x];
        totalSeconds += 60 * [a.durationMin intValue];
        totalSeconds += [a.durationSec intValue];
    }
    
    stats.totalMin = totalSeconds / 60;
    stats.totalSec = totalSeconds % 60;
    
    return stats;
}

-(NSDictionary*)save
{
    NSMutableDictionary* sd = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    [sd setObject:self.name forKey:P_Name];
    
    
    NSMutableArray* xsave = [[NSMutableArray alloc]initWithCapacity:self.activities.count];
    for(Activity* a in self.activities)
    {
        [xsave addObject:[a save]]; // saves dictionary of Activity in array
    }
    [sd setObject:xsave forKey:P_Activities];

    return sd;
}



-(NSString*)name
{
    if (_name) {
        return _name;
    }
    else {
        return @"new activity";
    }
}


-(void)setName:(NSString *)name
{
    _name = name;
}




@end
