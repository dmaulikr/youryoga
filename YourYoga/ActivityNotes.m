//
//  ActivityNotes.m
//  YourYoga
//
//  Created by john on 8/25/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "ActivityNotes.h"


@interface ActivityNotes ()
{
}

@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@end

@implementation ActivityNotes

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
    
    if (self.notesTextView && self.activity){
        [self.notesTextView setText:[self.activity notes]];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.notesTextView && self.activity){
        [self.view.window endEditing:YES];
        self.activity.notes = self.notesTextView.text;
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
