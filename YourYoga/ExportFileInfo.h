//
//  ExportFileInfo.h
//  YourYoga
//
//  Created by john on 8/28/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionsManager.h"


@interface ExportFileInfo : NSObject

@property (nonatomic, strong)NSString* Filename;
@property (nonatomic, strong)NSString* TemporaryFile;
@property (nonatomic, strong)NSData*   Data;
@property (nonatomic, strong)SessionsManager* ExportActivities;


-(id)initWithFilename:(NSString*)fn temp:(NSString*)temp data:(NSData*)data;

@end
