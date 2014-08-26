//
//  MoreItem.h
//  YourYoga
//
//  Created by john on 8/20/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreItem : NSObject

-(id)initWithTitle:(NSString*)title
       description:(NSString*)description
               url:(NSString*)url;


@property (nonatomic, strong)NSString* title;
@property (nonatomic, strong)NSString* desc;
@property (nonatomic, strong)NSString* url;

@end
