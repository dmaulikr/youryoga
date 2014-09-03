//
//  SharingEMailController.m
//  YourYoga
//
//  Created by john on 8/28/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import <MessageUI/MFMailComposeViewController.h>

#import "Utilities.h"
#import "SharingEMailController.h"

@interface SharingEMailController () <MFMailComposeViewControllerDelegate, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *activitiesPicker;

@end

@implementation SharingEMailController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)performEmail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        
        [controller setSubject:@"YourYoga Lessons"];
        [controller setMessageBody:@"I wanted to share the attached Lessons." isHTML:NO];
        
        
        [controller addAttachmentData:self.Export.Data mimeType:@"XML" fileName:self.Export.Filename];
        
        
        [self presentModalViewController:controller animated:YES];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"EMail Not Setup" message:@"Email is not setup on this device. Please configure it before trying this option" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.Export.ExportActivities.sessions count];
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Activities* activities = [self.Export.ExportActivities.sessions  objectAtIndex:row];
    
    return activities.name;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.activitiesPicker.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
    {
        //NSLog(@"It's away!");
    }
    else if (error)
    {
        [Utilities logError:[error description]];
    }
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
}


@end
