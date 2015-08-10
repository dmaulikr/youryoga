//
//  Utilities.m
//  AlertView
//
//  Created by john on 8/14/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//

#import "mach/mach.h"
#import "Utilities.h"



void _fn_assert(char* e, char* f, long line)
{
    NSString* exp = [NSString stringWithUTF8String:(char *)e];
    NSString* file = [NSString stringWithUTF8String:(char *)f];
    
    NSString* msg = [NSString stringWithFormat:@"Assert Failure:\n%@\nFile:%@ Line:%ld", exp, file, line];
    
    [Utilities logError:msg];
    
#if (TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE))
    //
    // Native Mac Mechanism for showing an Alert
    //
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        
        [[NSAlert alertWithMessageText:msg defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
    }];
    
#else
    
    //
    // iPhone/iPad mechanism for showing Alert. Notice schedule
    // the Alert to appear on the main (UI) thread. Trying to do
    // so on a background will cause program to halt.
    //
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Whoops", @"Unexpected error")
                                                        message:[NSString stringWithFormat:@"Apologies, something nasty happened. Please contact... \n\%@", msg]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK Button text")
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
#endif
    
    
}

@implementation Utilities

+ (void) logError:(NSString*)msg
{
    NSLog(@"ERROR: %@", msg);
}

UITableViewCell* _errorCell = nil;

+(UITableViewCell*)errorCell
{
    if (!_errorCell){
        _errorCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        _errorCell.textLabel.text = @"N/A";
    }
    return _errorCell;
}


+ (void) logException:(NSException*)exception faultSelector:(SEL)fault
{
    NSString* msg = [NSString stringWithFormat:@"(%@) Exception: %@", NSStringFromSelector(fault), exception.reason];
    [Utilities logError:[NSString stringWithFormat:@"(%@) Exception: %@", NSStringFromSelector(fault), msg]];
    
#if (TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE))
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        
        [[NSAlert alertWithMessageText:msg defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
    }];

#else
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Whoops", @"Unexpected exception")
                                                        message:[NSString stringWithFormat:@"Apologies, something nasty happened. Please contact... \n\%@", msg]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK Button text")
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
#endif
    
}



static long prevMemUsage = 0;
static long curMemUsage = 0;
static long memUsageDiff = 0;
static long curFreeMem = 0;

+(vm_size_t) freeMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pagesize;
}

+(vm_size_t) usedMemory {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(struct task_basic_info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}

+(void) captureMemUsage {
    prevMemUsage = curMemUsage;
    curMemUsage = [self usedMemory];
    memUsageDiff = curMemUsage - prevMemUsage;
    curFreeMem = [self freeMemory];
    
    
}

+(NSString*) captureMemUsageGetString{
    return [self captureMemUsageGetString: @"Memory used %7.1f (%+5.0f), free %7.1f kb"];
}

+(NSString*) captureMemUsageGetString:(NSString*) formatstring {
    [self captureMemUsage];
    return [NSString stringWithFormat:formatstring,curMemUsage/1000.0f, memUsageDiff/1000.0f, curFreeMem/1000.0f];
    
}


+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}


@end












