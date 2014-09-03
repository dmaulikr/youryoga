//
//  Activity.h
//  YourYoga
//
//  Created by john on 8/17/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

//@property (atomic, strong) NSString* pid;
@property (atomic, strong) NSString* name;
@property (atomic, strong) NSString* notes;
//@property (atomic, strong) NSString* imageName;
@property (atomic, strong) NSString* songTitle;
@property (atomic, strong) NSNumber* songId;
@property (atomic, strong) NSString* songURL;
@property (atomic, strong) NSString* videoURL;
@property (atomic, strong) NSString* durationMin;
@property (atomic, strong) NSString* durationSec;



-(id)initWithName:(NSString*)name notes:(NSString*)notes imageName:(NSString*)imageName;
-(id)init;

- (NSDictionary*)save;
-(id)initWithDictionary:(NSDictionary*)d;

-(NSString*)durationMinutesAndSecionds;

@end
