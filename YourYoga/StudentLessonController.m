//
//  StudentLessonController.m
//  YourYoga
//
//  Created by john on 8/26/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>

#import "StudentLessonController.h"
#import "Activity.h"
#import "ProgressCell.h"
#import "Utilities.h"

@interface StudentLessonController ()
{
    NSTimer* activeTimer;
    NSTimer* countdownTimer;
    
    NSInteger durationCounter;
    float durationTotal;
    
    NSInteger currentActivity;
    MPMusicPlayerController* mp;
    
}
@property (weak, nonatomic) IBOutlet UITableViewCell *activityTitleCell;
@property (weak, nonatomic) IBOutlet ProgressCell *progressCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *statusCell;

@end

@implementation StudentLessonController

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
    
    self.activityTitleCell.textLabel.text = self.session.name;
    
}

-(void)playSong:(NSNumber*)persistentId
{
    
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:persistentId forProperty:MPMediaItemPropertyPersistentID];
    MPMediaQuery *mySongQuery = [[MPMediaQuery alloc] init];
    [mySongQuery addFilterPredicate: predicate];
    mp = [MPMusicPlayerController applicationMusicPlayer];
    
    [mp setQueueWithQuery:mySongQuery];
    [mp play];
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    if (activeTimer){
        [activeTimer invalidate];
        activeTimer = nil;
    }
    if (countdownTimer){
        [countdownTimer invalidate];
        countdownTimer = nil;
    }
    
    [super viewWillDisappear:animated];
}


-(float)calculateDuration:(Activity*)activity
{
    float minutes = [activity.durationMin floatValue];
    float seconds = [activity.durationSec floatValue];
    
    return (minutes * 60) + seconds;
}


-(void)countDown:(NSTimer*)timer
{
    float tick = (float)durationCounter / durationTotal;
    ++durationCounter;
    [self.progressCell.timer setProgress:tick animated:FALSE];
}
-(void)taskAdvance:(NSTimer*)timer
{
    NSLog(@"taskAdvance");
    
    MASSERT(self.progressCell);
    MASSERT(self.progressCell.progress);
    
    [timer invalidate];
    activeTimer = nil;
    
    ++currentActivity;

    
    double progress = (double)currentActivity / (double)self.session.activities.count;
    [self.progressCell.progress setProgress:progress animated:TRUE];
    
    if (currentActivity < self.session.activities.count) {
        Activity* current = [self.session.activities objectAtIndex:currentActivity];
        if (current){
            [self playSong:current.songId];
            
            NSString* msg = [NSString stringWithFormat:@"%@:%@ %@",
                             current.durationMin,
                             current.durationSec,
                             current.name];
            
            self.statusCell.textLabel.text = msg;
            self.statusCell.detailTextLabel.text = current.notes;
            
            float duration = [self calculateDuration:current];
            
            durationCounter = 0;
            durationTotal = duration;
            [self.progressCell.timer setProgress:0.0f animated:FALSE];

            activeTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                           target:self
                                                         selector:@selector(taskAdvance:)
                                                         userInfo:nil
                                                          repeats:NO];
            [self.tableView reloadData];
            
        }
        
    }
    else {
        self.statusCell.textLabel.text = @"Done";
        self.statusCell.detailTextLabel.text = @"";
        [self.progressCell.progress setHidden:TRUE];
        [self.progressCell.timer setHidden:TRUE];
        [self.progressCell.timer setProgress:0.0f animated:FALSE];
        [self.progressCell.progress setProgress:0.0f animated:FALSE];
        [self.startLessonButton setEnabled:TRUE];
        if (mp){
            [mp stop];
            mp = nil;
        }
        
        if (countdownTimer){
            [countdownTimer invalidate];
            countdownTimer = nil;
        }

    }
    
}


- (IBAction)startLession:(id)sender {
    NSLog(@"startLession clicked");

    currentActivity = 0;
    durationCounter = 0;
    if (currentActivity < self.session.activities.count)
    {
        [self.startLessonButton setEnabled:FALSE];
        
        [self.progressCell.timer setProgress:0.0f animated:TRUE];
        [self.progressCell.progress setProgress:0.0f animated:TRUE];
        
        [self.progressCell.progress setHidden:FALSE];
        [self.progressCell.timer setHidden:FALSE];
        
        
        countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                          target:self
                                                        selector:@selector(countDown:)
                                                        userInfo:nil
                                                         repeats:YES];

        
        Activity* current = [self.session.activities objectAtIndex:currentActivity];
        if (current){
            [self playSong:current.songId];
            NSString* msg = [NSString stringWithFormat:@"%@:%@ %@",
                             current.durationMin,
                             current.durationSec,
                             current.name];
            
            self.statusCell.textLabel.text = msg;
            self.statusCell.detailTextLabel.text = current.notes;
            
            float duration = [self calculateDuration:current];
            durationCounter = 0;
            durationTotal = duration;
            [self.progressCell.timer setProgress:0.0f animated:FALSE];
            

            activeTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                           target:self
                                                         selector:@selector(taskAdvance:)
                                                         userInfo:nil
                                                          repeats:NO];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
