//
//  StudentController.m
//  YourYoga
//
//  Created by john on 8/26/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "StudentController.h"
#import "StudentLessonController.h"

#import "SessionsManager.h"
#import "Activities.h"
#import "Utilities.h"


static NSString* S_StartActivitity = @"startActivity";

@interface StudentController ()

@end

@implementation StudentController

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
    
    self.Manager = [SessionsManager defaultInstance];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activitiesUpdated) name:NM_ActivitiesHaveBeenUpdated object:nil];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)activitiesUpdated
{
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.Manager.sessions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    
    if (cell){
        Activities* activity = self.Manager.sessions[indexPath.row];
        cell.textLabel.text = activity.name;
    }
    
    return cell;
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:S_StartActivitity]){
        NSInteger i = [self.tableView indexPathForSelectedRow].row;
        if (i < 0) i = 0;
        
        Activities* activities = [self.Manager.sessions objectAtIndex:i];
        StudentLessonController* vc = (StudentLessonController*)segue.destinationViewController;
        if (vc){
            vc.session = activities;
        }
        
    }
    else {
        MASSERT(false);
    }
    
}

@end
