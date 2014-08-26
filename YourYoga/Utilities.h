//
//  Utilities.h
//  AlertView
//
//  Created by john on 8/14/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

//
// MASSERT macro calls a method in debug builds, gets optimized out in non-debug.
//
#ifdef DEBUG
    void _fn_assert(char* exp, char* file, long line);
    #define MASSERT(e) ((void) ((e) ? (void)0 : _fn_assert ((char*)#e, (char*)__FILE__, __LINE__)))
#else
    #define MASSERT(e) ((void)0)
#endif



@interface Utilities : NSObject

+ (void) logError:(NSString*)msg;
+ (void) logException:(NSException*)ex faultSelector:(SEL)fault;

+(UITableViewCell*)errorCell;

+(NSString*) captureMemUsageGetString;

+ (NSString *)GetUUID;

@end
