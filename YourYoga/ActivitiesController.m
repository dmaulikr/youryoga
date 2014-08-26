//
//  ScheduleController.m
//  YourYoga
//
//  Created by john on 8/18/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "ActivitiesController.h"
#import "SessionsManager.h"
#import "Activities.h"
#import "Activity.h"
#import "tfCell.h"

#import "ActivityEdit.h"
#import "Utilities.h"

//
// Dynamic TableView Sample including support for Edit (delete), and Move rows.
//


#define ACTIVITY_CELL @"workoutCell"
static NSString* S_ActivityNameCell = @"ActivityNameCell";

#define NUMBER_OF_DETAIL_LINES 4

@interface ActivitiesController ()
{
    TextFieldCell* tfCell;
}


@end

@implementation ActivitiesController

enum {
    Section_Name,
    Section_Details,
    Section_Count,
};

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
    @try {
        [super viewDidLoad];
        MASSERT(self.session);
        self.clearsSelectionOnViewWillAppear = NO;
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view.window endEditing:YES];
    self.session.name = tfCell.textField.text;
    [[SessionsManager defaultInstance]save];
    
}
-(void)didReceiveMemoryWarning
{
    // Drop the overflow, out of memory
    //_manager = [[ActivityManager alloc]init];
    
    NSLog(@"ScheduleController encountered memory-warning");
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return Section_Count;
}

-(void)viewWillAppear:(BOOL)animated
{
    @try {
        [self.tableView reloadData];
        [super viewWillAppear:animated];
        
#ifdef DEBUG
        NSLog(@"%@", [Utilities captureMemUsageGetString]);
#endif
        
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
    @finally {
        NSMutableArray* buttons = [[NSMutableArray alloc]init];
        //UIBarButtonItem* back = self.navigationItem.leftBarButtonItem;
        //MASSERT(back);
        UIBarButtonItem* add = self.navigationItem.rightBarButtonItem;
        
        //UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goBack)];
        [buttons addObject:add];
        [buttons addObject:self.editButtonItem];
        self.navigationItem.rightBarButtonItems = buttons;;
    }
}


-(void)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rc;
    @try {
        if (Section_Name == section) {
            rc = 1;
        }
        else {
            rc = self.session.activities.count;
        }
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
        rc = 0;
    }
    
    return rc;
}

- (IBAction)editClicked:(id)sender {
    @try {
        [self.tableView setEditing:!self.tableView.editing];
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [self.session.activities removeObjectAtIndex:indexPath.row];
            [[SessionsManager defaultInstance] save];
            [self.tableView reloadData];
        }
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try {
        
        if ([segue.identifier isEqualToString:@"addAction"]){
            Activity* add = [[Activity alloc]init];
            [self.session.activities addObject:add];
            ActivityEdit* edit = (ActivityEdit*)segue.destinationViewController;
            edit.activity = add;
        }
        else if ([segue.identifier isEqualToString:@"editAction"]){
            NSInteger i = [self.tableView indexPathForSelectedRow].row;
            if (i < 0) i = 0;
            
            Activity* activity = [self.session.activities objectAtIndex:i];
            if (activity){
                ActivityEdit* edit = (ActivityEdit*)segue.destinationViewController;
                edit.activity = activity;
            }
        }
        else {
            MASSERT(false);
        }
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > Section_Name) return YES;
    else return NO;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    @try {
        Activity* activity = [self.session.activities objectAtIndex:sourceIndexPath.row];
        [self.session.activities removeObjectAtIndex:sourceIndexPath.row];
        [self.session.activities insertObject:activity atIndex:destinationIndexPath.row];
        [self.session save];
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView detailCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    @try {
        cell = [tableView dequeueReusableCellWithIdentifier:ACTIVITY_CELL forIndexPath:indexPath];
        if (cell){
            Activity* activity = [self.session.activities objectAtIndex:indexPath.row];
            if (activity){
                cell.textLabel.text = activity.name;
                cell.detailTextLabel.text = activity.notes;
                cell.detailTextLabel.numberOfLines = NUMBER_OF_DETAIL_LINES;
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                NSString* imageName = activity.imageName ? activity.imageName : @"default.png";
                cell.imageView.image = [UIImage imageNamed:imageName];
            }
        }
        else {
            MASSERT(cell); // This should NEVER happen, only way it does is if we change the name of the activity cell identifier
        }
    }
    @catch (NSException *exception) {
        cell = [Utilities errorCell];
        cell.detailTextLabel.text = exception.description;
    }
    
    return cell;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView nameCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TextFieldCell *cell;
    
    @try {
        tfCell = [tableView dequeueReusableCellWithIdentifier:S_ActivityNameCell forIndexPath:indexPath];
        if (tfCell){
            Activity* activity = [self.session.activities objectAtIndex:indexPath.row];
            if (activity){
                [tfCell.textField setText:self.session.name];
            }
        }
        else {
            MASSERT(tfCell); // This should NEVER happen, only way it does is if we change the name of the activity cell identifier
        }
    }
    @catch (NSException *exception) {
        //cell = [Utilities errorCell];
        //cell.detailTextLabel.text = exception.description;
    }
    
    return tfCell;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    @try {
        switch (indexPath.section) {
            case Section_Name:
                cell = [self tableView:tableView nameCellForRowAtIndexPath:indexPath];
                break;
                
            default:
                cell = [self tableView:tableView detailCellForRowAtIndexPath:indexPath];
                break;
        }
    }
    @catch (NSException *exception) {
        cell = [Utilities errorCell];
        cell.detailTextLabel.text = exception.description;
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > Section_Name) return YES;
    else return NO;
}


@end
