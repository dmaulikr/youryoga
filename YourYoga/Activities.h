//
//  Activities.h
//  YourYoga
//
//  Created by john on 8/26/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"
#import "ActivityStats.h"


@interface Activities : NSObject
{
    NSString* _name;
    NSMutableArray* _activities;
}

@property (atomic, strong) NSString* name;
@property (atomic, strong) NSMutableArray* activities;

+(ActivityStats*)summaryStats:(Activities*)activities;

-(id)init;
-(id)initWithDictionary:(NSDictionary*)d;
-(NSDictionary*)save;


-(void)logActivity:(Activity*)activity duration:(NSTimeInterval)duration;

@end
