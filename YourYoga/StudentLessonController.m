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
#import "LessonWebCell.h"


@interface StudentLessonController ()
{
    NSInteger durationCounter;
    float durationTotal;
    
    NSInteger currentActivity;
    MPMusicPlayerController* mp;
    
}
//@property (weak, nonatomic) IBOutlet UITableViewCell *activityTitleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *statusCell;
@property (weak, nonatomic) IBOutlet LessonWebCell *webCell;

@property (nonatomic, strong) Activity* activityTracking;
@property (nonatomic, strong) NSDate* start;
@property (nonatomic, strong) NSDate* end;

//@property (weak, nonatomic) IBOutlet UITableViewCell *songCell;

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

-(void)refreshPrompt
{
    self.navigationItem.prompt = [NSString stringWithFormat:@"%@ %ld of %ld", self.session.name, (long)(1+currentActivity), (long)self.session.activities.count];
}

-(void)backPressed:(NSObject*)sender
{
    [self trackActivityChange:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self refreshPrompt];
    
    UIBarButtonItem* play = self.navigationItem.rightBarButtonItem;
    UIBarButtonItem* nextText = [[UIBarButtonItem alloc]initWithTitle:@"Next Pose" style:UIBarButtonItemStyleDone target:self action:@selector(startLession:)];
    NSArray* rightItems = [[NSArray alloc]initWithObjects:play,nextText, nil];
    self.navigationItem.rightBarButtonItems = rightItems;
    
    UIBarButtonItem* back = self.navigationItem.leftBarButtonItem;
    if (!back){
        back = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backPressed:)];
        self.navigationItem.leftBarButtonItem = back;
    }
    //back.target = self;
    //back.action = @selector(backPressed:);
    
    //
    // Register first activity as started as soon as it's displayed
    currentActivity = 0;
    self.start = [NSDate date];
    if (self.session.activities && self.session.activities.count > 0){
        self.activityTracking = self.session.activities[currentActivity];
        
        [self showActivity:[self.session.activities objectAtIndex:0]];
        [self showVideo:[self.session.activities objectAtIndex:0]];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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


-(void)showVideo:(Activity*)current
{
    if (current.videoURL){
        NSURL* url = [NSURL URLWithString:current.videoURL];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url];
        [self.webCell.webView loadRequest:request];
    }
}


-(void)showActivity:(Activity*)current
{
    NSString* msg = [NSString stringWithFormat:@"%@ (%@:%@)",
                     current.name,
                     (current.durationMin)?current.durationMin:@"0",
                     current.durationSec?current.durationSec:@"0"];

    NSString* details;
    
    if (current.songTitle && current.songTitle.length > 0) {
        details = [NSString stringWithFormat:@"%@\n%@", current.notes, current.songTitle];
    }
    else {
        details = current.notes;
    }
    
    self.statusCell.textLabel.text = msg;
    self.statusCell.detailTextLabel.text = details;

}

-(void)viewWillDisappear:(BOOL)animated
{
    if (mp){
        [mp stop];
        mp = nil;
    }

    //[self trackActivityChange:nil];
    [super viewWillDisappear:animated];
}

/*
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
    //[self.progressCell.timer setProgress:tick animated:FALSE];
}
*/

-(void)advance
{
    NSLog(@"taskAdvance");
    
    ++currentActivity;
    if (currentActivity >= self.session.activities.count){
        currentActivity = 0;
    }
    
    if (self.session.activities.count <= 0) return;
    
    Activity* current = [self.session.activities objectAtIndex:currentActivity];
    if (current){
        [self trackActivityChange:current];
        self.start = [NSDate date];
        [self showVideo:current];
        [self playSong:current.songId];
        [self showActivity:current];
        [self.tableView reloadData];
        [self refreshPrompt];
    }
}


-(void)trackActivityChange:(Activity*)current
{
    if (self.activityTracking){
        self.end = [NSDate date];
        // log duration
        NSTimeInterval secs = [self.end timeIntervalSinceDate:self.start];
        if(secs){
            [self.session logActivity:self.activityTracking duration:secs];
        }
    }
    self.activityTracking = current;
}


- (IBAction)startLession:(id)sender {
    [self advance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
