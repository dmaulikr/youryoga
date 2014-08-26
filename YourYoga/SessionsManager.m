//
//  ActivityManager.m
//  YourYoga
//
//  Created by john on 8/17/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#define DOCUMENTS_FILE @"activities.V1.xml"
#import "SessionsManager.h"
#import "Utilities.h"

static NSString* P_Sessions = @"m.sessions";


@implementation SessionsManager
{
    
}

@synthesize sessions = _sessions;

static SessionsManager* _default;


+(SessionsManager*)defaultInstance
{
    //
    // BUGBUG
    // This is NOT thread safe
    //
    if (!_default) {
        _default = [[SessionsManager alloc]init];
        if (_default){
            [_default load];
        }
    }
    return _default;
}


-(id)init
{
    self = [super init];
    if (self)
    {
        [self load];
    }
    return self;
}



-(bool)addActivities:(Activities*)activities
{
    [self.sessions addObject:activities];
    return true;
}


-(NSString*)defaultFilename
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (!paths || paths.count < 1){
        NSAssert(paths && paths.count > 0, @"NSSearchPathForDirectoriesInDomains failed");
        return nil;
    }
    NSString* path = [paths objectAtIndex:0];
    if (!path) {
        NSAssert(path, @"NSSearchPathForDirectoriesInDomains failed");
        return nil;
    }
    
    NSString* file = [path stringByAppendingPathComponent:DOCUMENTS_FILE];
    
    return file;
}


-(void)load
{
    do
    {
        NSString* fn = [self defaultFilename];
        if (!fn){
            break;
        }
        
        self.sessions = [[NSMutableArray alloc]init];
        
        NSDictionary* d = [[NSMutableDictionary alloc]initWithContentsOfFile:fn];
        if (d){
            NSMutableArray* load = [d objectForKey:P_Sessions];
            if (load){
                for(NSDictionary* d in load){
                    Activities* a = [[Activities alloc]initWithDictionary:d];
                    [self.sessions addObject:a];
                }
            }
        }
        
    }while (false);
}


-(void)save
{
    do
    {
        NSString* fn = [self defaultFilename];
        if (!fn){
            break;
        }
        
        NSMutableDictionary* save = [[NSMutableDictionary alloc]initWithCapacity:2];
        
        NSMutableArray* xsave = [[NSMutableArray alloc]initWithCapacity:self.sessions.count];
        for(Activities* a in self.sessions)
        {
            [xsave addObject:[a save]];
        }
        [save setObject:xsave forKey:P_Sessions];
        
        
        if (NO == [save writeToFile:fn atomically:YES])
        {
            NSLog(@"***ERROR: file save failed! %@", fn);
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NM_ActivitiesHaveBeenUpdated object:self.sessions];
        
    }while (false);
    
}

@end
