//
//  MoreItem.m
//  YourYoga
//
//  Created by john on 8/20/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//

#import "MoreItem.h"

@implementation MoreItem

-(id)initWithTitle:(NSString*)title
       description:(NSString*)description
               url:(NSString*)url
{
    self = [super init];
    if (self){
        _title = title;
        _desc = description;
        _url = url;
    }
    return self;
}

-(NSString*)description
{
    return _desc;
}

@end
