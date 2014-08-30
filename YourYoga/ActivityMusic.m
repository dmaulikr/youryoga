//
//  ActivityMusic.m
//  YourYoga
//
//  Created by john on 8/25/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "Utilities.h"
#import "ActivityMusic.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MusicSelectionCell.h"

@interface ActivityMusic () <MPMediaPickerControllerDelegate>
{
    //NSString* soundName;
    //NSString* soundUrl;
    bool playing;
    
}
@property (weak, nonatomic) IBOutlet MusicSelectionCell *musicTitleCell;

@end

@implementation ActivityMusic

- (IBAction)enableITunesClicked:(id)sender {
    UISwitch* sw = (UISwitch*)sender;
    self.activity.songId = [[NSNumber alloc]initWithInt:0];
    self.activity.songTitle = @"";
    
    if (sw.on)
    {
        [self pickSong];
    }
    [self.tableView reloadData];
}

/*
- (IBAction)selectMusic:(id)sender {
    NSLog(@"selectMusic clicked");

    [self pickSong];
}
*/

- (IBAction)playMusic:(id)sender {
    if (self.activity.songId){
        if (playing){
            MPMusicPlayerController* mp = [MPMusicPlayerController applicationMusicPlayer];
            [mp stop];
            playing = false;
        }
        else {
            [self playSong:self.activity.songId];
            playing = true;
        }
    }
}


-(void) pickSong
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO;
    mediaPicker.prompt = NSLocalizedString(@"Select Song", nil);
    [mediaPicker loadView];
    [self.navigationController presentViewController:mediaPicker animated:YES completion:nil];
}


-(void) mediaPicker:(MPMediaPickerController *) mediaPicker2 didPickMediaItems:(MPMediaItemCollection *) mediaItemCollection {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    MPMediaItem *mediaItem = [[mediaItemCollection items] objectAtIndex:0];
    NSString* songTitle = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
    NSString* albumTitle = [mediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSString* artist = [mediaItem valueForProperty:MPMediaItemPropertyArtist];
    
    
    //NSString* soundUrl = [[mediaItem valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
    NSNumber* song = [mediaItem valueForProperty:MPMediaItemPropertyPersistentID];
    
    self.activity.songId = song;
    self.activity.songTitle = [NSString stringWithFormat:@"%@ - %@ (%@)", albumTitle, songTitle, artist];
    
    [self refreshView];
}

-(void)playSong:(NSNumber*)persistentId
{
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:persistentId forProperty:MPMediaItemPropertyPersistentID];
    MPMediaQuery *mySongQuery = [[MPMediaQuery alloc] init];
    [mySongQuery addFilterPredicate: predicate];
    MPMusicPlayerController* mp = [MPMusicPlayerController applicationMusicPlayer];
    
    [mp setQueueWithQuery:mySongQuery];
    [mp play];

}


-(void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

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
    MASSERT(self.activity);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshView];
    
}

-(void)refreshView
{
    if ([self.activity.songId integerValue] != 0) {
        self.musicTitleCell.textField.text  = self.activity.songTitle;
        self.musicTitleCell.isTunesEnabled.on = YES;
    }
    else {
        self.musicTitleCell.textField.text  = self.activity.songTitle;
        self.musicTitleCell.isTunesEnabled.on = NO;
        
    }
    [self.tableView reloadData];

}
@end
