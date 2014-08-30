//
//  ExportFileInfo.m
//  YourYoga
//
//  Created by john on 8/28/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "ExportFileInfo.h"
#import "Utilities.h"

@implementation ExportFileInfo


-(id)initWithFilename:(NSString*)fn temp:(NSString*)temp data:(NSData*)data
{
    self = [super init];
    if (self){
        _Filename = fn;
        MASSERT(_Filename);
        
        _TemporaryFile = temp;
        MASSERT(_TemporaryFile);
        
        _Data = data;
        //MASSERT(_Data);

    }
    return self;
}


@end
