//
//  SessionController.m
//  YourYoga
//
//  Created by john on 8/26/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "AppDelegate.h"
#import "ActivityStats.h"

#import "SessionController.h"
#import "ActivitiesController.h"

#import "Utilities.h"

static NSString* S_EditActivities = @"editActivities";
static NSString* S_AddActivities = @"addActivities";

enum Buttons {
    Button_OK,
    Button_Cancel,
};

@interface SessionController ()
{
    //
    // BUGBUG
    // Potential race condition using a single instance field. If user quickly opens two different CSV's
    // then we'll have a problem with this strategy. Chances of that case are minimal.
    // jkountz Aug 28, 2014
    NSString* importFileName;
}


@end

@implementation SessionController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)doImport:(NSString*)file
{
    if (file){
        NSLog(@"Importing %@", file);
        SessionsManager* other = [[SessionsManager alloc]initUsingFile:file];
        if (other){
            [self.Manager import:other];
            [self.Manager save];
            [self.tableView reloadData];
        }
        else {
            MASSERT(false);
        }
    }
    else {
        MASSERT(false);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == Button_OK){
        [self doImport:importFileName];
    }
}


-(void)importFile:(NSNotification*)notify
{
    //NSLog(@"Notified of import");
    importFileName = [notify.userInfo objectForKey:S_NotifyImportFile];
    
    NSString* msg = [NSString stringWithFormat:@"Import new activities?"];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Confirm" message:msg delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(importFile:) name:S_NotifyImportFile object:nil];
    
    self.Manager = [SessionsManager defaultInstance];
    

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self initializeMenu];
}

-(void)helpMenu
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://youryogapp.blogspot.com/2014/08/yogi-view.html"]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MASSERT(self.Manager);
    MASSERT(self.Manager.sessions);
    
    return self.Manager.sessions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionsCell" forIndexPath:indexPath];
    
    if (cell){
        Activities* activities = [self.Manager.sessions objectAtIndex:indexPath.row];
        cell.textLabel.text = activities.name;
        
        ActivityStats* stats = [Activities summaryStats:activities];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%ld) Poses taking %ldm:%lds",
                                     (long)stats.totalTasks,
                                     (long)stats.totalMin,
                                     (long)stats.totalSec];
                                     
    }
    else {
        cell = [Utilities errorCell];
    }
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.Manager.sessions removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.Manager save];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    Activities* activities = [self.Manager.sessions objectAtIndex:fromIndexPath.row];
    [self.Manager.sessions removeObjectAtIndex:fromIndexPath.row];
    [self.Manager.sessions insertObject:activities atIndex:toIndexPath.row];
    [self.Manager save];
    
    //[self.Manager.sessions removeObjectAtIndex:fromIndexPath.row];

}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:S_EditActivities]){
        NSInteger i = [self.tableView indexPathForSelectedRow].row;
        if (i < 0) i = 0;
        
        Activities* activities = [self.Manager.sessions objectAtIndex:i];
        ActivitiesController* vc = (ActivitiesController*)segue.destinationViewController;
        if (vc){
            vc.session = activities;
        }
        
    }
    else if ([segue.identifier isEqualToString:S_AddActivities]){
        
        Activities* activities = [[Activities alloc]init];
        [self.Manager.sessions addObject:activities];
        
        ActivitiesController* vc = (ActivitiesController*)segue.destinationViewController;
        if (vc){
            vc.session = activities;
        }
    }
    
}


@end
