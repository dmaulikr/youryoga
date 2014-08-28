//
//  ActivityMusic.m
//  YourYoga
//
//  Created by john on 8/25/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "ActivityMusic.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ActivityMusic () <MPMediaPickerControllerDelegate>
{
    NSString* soundName;
    NSString* soundUrl;
    
}

@end

@implementation ActivityMusic

- (IBAction)selectMusic:(id)sender {
    NSLog(@"selectMusic clicked");

    [self pickSong];
}
- (IBAction)playMusic:(id)sender {
    if (self.activity.songId){
        [self playSong:self.activity.songId];
    }
}

-(void) pickSong
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO;
    mediaPicker.prompt = NSLocalizedString(@"Select Your Favourite Song!", nil);
    [mediaPicker loadView];
    [self.navigationController presentViewController:mediaPicker animated:YES completion:nil];
}

#pragma mark - MPMediaPickerController delegate

-(void) mediaPicker:(MPMediaPickerController *) mediaPicker2 didPickMediaItems:(MPMediaItemCollection *) mediaItemCollection {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    MPMediaItem *mediaItem = [[mediaItemCollection items] objectAtIndex:0];
    soundName = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
    soundUrl = [[mediaItem valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
    NSNumber* song = [mediaItem valueForProperty:MPMediaItemPropertyPersistentID];
    
    //[self playSong:song];
    self.activity.songId = song;
    self.activity.songTitle = soundName;
    
    //NSLog(@"soundName: %@", soundName);
    //NSLog(@"soundUrl: %@", soundUrl);
    //NSLog(@"s: %@", song);
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
