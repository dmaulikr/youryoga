//
//  SharingController.m
//  YourYoga
//
//  Created by john on 8/28/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "SharingController.h"
#import "Utilities.h"


@interface SharingController ()

@end

@implementation SharingController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeMenu];
}

-(void)helpMenu
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://youryogapp.blogspot.com/2014/08/sharing.html"]];
}

-(void)initializeMenu
{
    UIBarButtonItem* existing = self.navigationItem.rightBarButtonItem;
    if (existing){
        NSMutableArray* ma = [[NSMutableArray alloc]init];
        UIBarButtonItem* helpItem = [[UIBarButtonItem alloc]initWithTitle:@"Help-?" style:UIBarButtonItemStylePlain target:self action:@selector(helpMenu)];
        [ma addObject:helpItem];
        [ma addObject:existing];
        self.navigationItem.rightBarButtonItems = ma;
    } else{
        UIBarButtonItem* helpItem = [[UIBarButtonItem alloc]initWithTitle:@"Help-?" style:UIBarButtonItemStylePlain target:self action:@selector(helpMenu)];
        MASSERT(helpItem);
        if (helpItem){
            self.navigationItem.rightBarButtonItem = helpItem;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
