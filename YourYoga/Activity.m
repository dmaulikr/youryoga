//
//  Activity.m
//  YourYoga
//
//  Created by john on 8/17/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "Activity.h"
#import "Utilities.h"

static NSString* P_Pid = @"pid";
static NSString* P_Name = @"name";
static NSString* P_Notes = @"notes";
static NSString* P_Image = @"image";
static NSString* P_SongName = @"song.name";
static NSString* P_SongId = @"song.id";

static NSString* P_DurationMin = @"duration.min";
static NSString* P_DurationSec = @"duration.sec";

@interface Activity()
{
    NSMutableDictionary* _properties;
    
}

@end


@implementation Activity

-(id)initWithDictionary:(NSDictionary*)d
{
    self = [super init];
    if (self)
    {
        _properties = [[NSMutableDictionary alloc]initWithDictionary:d];
        
        //
        // This case covers backwards compatibility, where, Pid did not exist in the original dictionary
        if (!self.pid){
            self.pid = [Utilities GetUUID];
        }

    }
    return self;
}


-(id)initWithName:(NSString*)name notes:(NSString*)notes imageName:(NSString*)imageName
{
    self = [self init];
    if (self){
        MASSERT(self.pid);
        
        if (!name) name = @"Workout";
        if (!notes) notes = @"No pain, no gain";
        if (!imageName) imageName = @"default.png";
        
        [self setName:name];
        [self setNotes:notes];
        [self setImageName:imageName];
        
    }
         return self;
}


-(id)init
{
    self = [super init];
    if (self)
    {
        _properties = [[NSMutableDictionary alloc]init];
        
        if (!self.pid) self.pid = [Utilities GetUUID];
    }
    return self;
}


-(void)setPropertiy:(NSString*)PropertyId value:(NSString*)value
{
    if (value){
        [_properties setObject:value forKey:PropertyId];
    }
    else {
        NSAssert(value, @"null value not allowed.");
    }

}


-(NSString*)getPropertiy:(NSString*)PropertyId
{
    NSString* rc = [_properties objectForKey:PropertyId];
    return rc;
}


-(NSString*)pid
{
    return [self getPropertiy:P_Pid];
}


-(void)setPid:(NSString *)pid
{
    [self setPropertiy:P_Pid value:pid];
}


-(NSString*)name
{
    return [self getPropertiy:P_Name];
}


-(void)setName:(NSString *)name
{
    [self setPropertiy:P_Name value:name];
}


-(NSString*)notes
{
    return [self getPropertiy:P_Notes];
}


-(void)setNotes:(NSString *)notes
{
    [self setPropertiy:P_Notes value:notes];
}


-(NSString*)imageName
{
    return [self getPropertiy:P_Image];
}


-(void)setImageName:(NSString *)imageName
{
    [self setPropertiy:P_Image value:imageName];
}


-(NSString*)durationMin
{
    return [self getPropertiy:P_DurationMin];
}


-(void)setDurationMin:(NSString *)d
{
    [self setPropertiy:P_DurationMin value:d];
}


-(NSString*)durationSec
{
    return [self getPropertiy:P_DurationSec];
}


-(void)setDurationSec:(NSString *)d
{
    [self setPropertiy:P_DurationSec value:d];
}


-(NSString*)durationMinutesAndSecionds
{
    return [NSString stringWithFormat:@"Min %@, Sec %@", self.durationMin?self.durationMin:@"0", self.durationSec?self.durationSec:@"0"];
}


-(NSString*)songTitle
{
    return [self getPropertiy:P_SongName];
}


-(void)setSongTitle:(NSString *)name
{
    [self setPropertiy:P_SongName value:name];
}



-(NSNumber*)songId
{
    NSNumber* rc = [_properties objectForKey:P_SongId];
    return rc;
}


-(void)setSongId:(NSNumber *)name
{
    //[self setPropertiy:P_SongId value:[name stringValue]];
    [_properties setObject:name forKey:P_SongId];
}



- (NSDictionary*)save
{
    return _properties;
}


@end
