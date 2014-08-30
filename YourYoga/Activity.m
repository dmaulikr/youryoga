//
//  Activity.m
//  YourYoga
//
//  Created by john on 8/17/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "Activity.h"
#import "Utilities.h"

//static NSString* P_Pid = @"pid";
static NSString* P_Name = @"activity.name";
static NSString* P_Notes = @"activity.notes";
static NSString* P_Image = @"activity.image";
static NSString* P_SongName = @"activity.song.name";
static NSString* P_SongId = @"activity.song.id";
static NSString* P_VideoURL = @"activity.video.url";

static NSString* P_DurationMin = @"activity.duration.min";
static NSString* P_DurationSec = @"activity.duration.sec";

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
        /*
        if (!self.pid){
            self.pid = [Utilities GetUUID];
        }
        */

    }
    return self;
}


-(id)initWithName:(NSString*)name notes:(NSString*)notes imageName:(NSString*)imageName
{
    self = [self init];
    if (self){
        //MASSERT(self.pid);
        
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
        
        //if (!self.pid) self.pid = [Utilities GetUUID];
    }
    return self;
}


-(void)setPropertiy:(NSString*)PropertyId value:(NSString*)value
{
    [_properties setObject:(value)?value:@"" forKey:PropertyId];

}


-(NSString*)getPropertiy:(NSString*)PropertyId
{
    NSString* rc = [_properties objectForKey:PropertyId];
    return (rc)?rc:@"";
}

/*
-(NSString*)pid
{
    return [self getPropertiy:P_Pid];
}


-(void)setPid:(NSString *)pid
{
    [self setPropertiy:P_Pid value:pid];
}
*/


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
    NSString* rc = [self getPropertiy:P_DurationMin];
    return (rc.length>0)?rc:@"0";
}


-(void)setDurationMin:(NSString *)d
{
    [self setPropertiy:P_DurationMin value:d];
}


-(NSString*)durationSec
{
    NSString* rc = [self getPropertiy:P_DurationSec];
    return (rc.length>0)?rc:@"0";
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
    return (rc)?rc:[NSNumber numberWithInt:0];
}


-(void)setSongId:(NSNumber *)name
{
    //[self setPropertiy:P_SongId value:[name stringValue]];
    [_properties setObject:name forKey:P_SongId];
}


-(NSString*)videoURL
{
    NSString* rc = [_properties objectForKey:P_VideoURL];
    return rc;
}


-(void)setVideoURL:(NSNumber *)name
{
    [_properties setObject:name forKey:P_VideoURL];
}


- (NSDictionary*)save
{
    return _properties;
}


@end
