//
//  Activities.h
//  YourYoga
//
//  Created by john on 8/26/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activities : NSObject
{
    NSString* _name;
    NSMutableArray* _activities;
}

@property (atomic, strong) NSString* name;
@property (atomic, strong) NSMutableArray* activities;

-(id)init;
-(id)initWithDictionary:(NSDictionary*)d;
-(NSDictionary*)save;

@end
