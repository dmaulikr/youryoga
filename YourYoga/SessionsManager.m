//
//  ActivityManager.m
//  YourYoga
//
//  Created by john on 8/17/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#define DEF_DOCUMENTS_FILE @"activities.V1.xml"
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




-(id)initUsingFile:(NSString*)file
{
    self = [super init];
    if (self)
    {
        _documentFile = file;
        [self load];
    }
    return self;
}



-(id)init
{
    self = [super init];
    if (self)
    {
        //_documentFile = DEF_DOCUMENTS_FILE;
        [self load];
    }
    return self;
}


-(void)import:(SessionsManager*)other
{
    if (other){
        for(Activities* activities in other.sessions){
            [self addActivities:activities];
        }
    }
}

-(bool)addActivities:(Activities*)activities
{
    [self.sessions addObject:activities];
    return true;
}


-(NSString*)defaultFilename
{
    if (self.documentFile) {
        return self.documentFile;
    }
    
    //self.documentFile = DEF_DOCUMENTS_FILE;
    
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
    
    
    NSString* file = [path stringByAppendingPathComponent:DEF_DOCUMENTS_FILE];
    
    return file;
}


-(void)extractStartingActivities
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"startingactivities" ofType:@"xml"];
    SessionsManager* samples = [[SessionsManager alloc]initUsingFile:filepath];
    if(samples){
        [self import:samples];
    }
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
        //NSLog(@"Loading file %@", fn);
        
        // try loading file
        NSDictionary* d = [[NSMutableDictionary alloc]initWithContentsOfFile:fn];
        if (!d) {
            // try loading from url, the case for importing xml files
            d = [[NSMutableDictionary alloc]initWithContentsOfURL:[NSURL URLWithString:fn]];
        }
        if (d){
            NSMutableArray* load = [d objectForKey:P_Sessions];
            if (load){
                for(NSDictionary* d in load){
                    Activities* a = [[Activities alloc]initWithDictionary:d];
                    [self.sessions addObject:a];
                }
            }
        }
        else {
            [self extractStartingActivities];
        }
        
        
        
    }while (false);
}


-(void)save
{
    [self saveAndNotify:YES];
    
}

-(void)saveAndNotify:(BOOL)andNotify
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
        
        if (andNotify)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:NM_ActivitiesHaveBeenUpdated object:self.sessions];
        }
        
    }while (false);
    
}

@end
