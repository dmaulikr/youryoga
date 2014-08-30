//
//  EditScheduleController.m
//  YourYoga
//
//  Created by john on 8/18/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "ActivityEdit.h"
#import "SessionsManager.h"
#import "Activities.h"
#import "Utilities.h"
#import "ActivityNotes.h"
#import "ActivityDuration.h"
#import "ActivityType.h"


//
// Static TableView Sample
//

@interface ActivityEdit () <UITextFieldDelegate, UITextViewDelegate>
{
    NSMutableArray* excerciseRoutines;
    NSMutableArray* excerciseImages;
    NSString* selectedImage;
    
}
@property (weak, nonatomic) IBOutlet UITableViewCell *activityNameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *activityDurationCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *activityNotesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *activityMusicCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *activityVideoCell;


@end

@implementation ActivityEdit

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
 * Deprecated in-favor of saving when view disappears, who needs a button
 * just do the right thing and Users don't have to understand the details...
 
- (IBAction)saveChanges:(id)sender {
    @try {
        [self.view.window endEditing:YES];
        [[ActivityManager defaultInstance]save];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
}
*/

-(void)viewWillDisappear:(BOOL)animated
{
    @try {
        [self.view.window endEditing:YES];
        [[SessionsManager defaultInstance]save];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
    @finally {
        [super viewWillDisappear:animated];
    }
}

-(void)activitiesUpdated
{
    [self refreshView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    @try {
        
        //
        // This notification prepares the code for when we begin saving changes on a background thread. Once changes are saved, we'll broadcast
        // a notification and the Views can then update.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activitiesUpdated) name:NM_ActivitiesHaveBeenUpdated object:nil];

    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
}

//----------------------------------------------------------------------------
// Private helper method called internally (wrapped with try/catch)
// to refresh all view properties
//
-(void)refreshView
{
    if (self.activity){
        if (self.activityNameCell){
            self.activityNameCell.detailTextLabel.text = self.activity.name;
        }
        if (self.activityNotesCell){
            self.activityNotesCell.detailTextLabel.text = self.activity.notes;
        }
        if (self.activityMusicCell){
            self.activityMusicCell.detailTextLabel.text = self.activity.songTitle;
        }
        if (self.activityDurationCell){
            self.activityDurationCell.detailTextLabel.text = [self.activity durationMinutesAndSecionds];
        }
        if (self.activityVideoCell){
            self.activityVideoCell.detailTextLabel.text = [self.activity videoURL];
        }
        [self.tableView reloadData];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    @try {
        [self refreshView];
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
    @finally {
        [super viewWillAppear:animated];
    }
    
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try {
        //
        // BUGBUG: This is a hack. All I want is access to the activity property.
        // If i was not such a lazy ass, I would have implemented a base class and this would have been safe.
        // jkountz 8-25-2014
        //
        ((ActivityType*)[segue destinationViewController]).activity = self.activity;
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
    
}
@end
