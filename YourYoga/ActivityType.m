//
//  ActivityType.m
//  YourYoga
//
//  Created by john on 8/25/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "ActivityType.h"
#import "Utilities.h"

@interface ActivityType () <UITextFieldDelegate, UIPickerViewDelegate>
{
    NSMutableArray* excerciseRoutines;
    //NSMutableArray* excerciseImages;
    
}
@property (weak, nonatomic) IBOutlet UIPickerView *excercisePicker;
@property (weak, nonatomic) IBOutlet UITextField *activityNameText;


@end

@implementation ActivityType

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
    [self loadData];
    self.excercisePicker.delegate = self;
    
    [self.activityNameText setText:self.activity.name];
    
    for(int x = 0; x < excerciseRoutines.count; ++x){
        NSString* s = [excerciseRoutines objectAtIndex:x];
        if ([s isEqualToString:_activity.name]){
            [self.excercisePicker selectRow:x inComponent:0 animated:YES];
            
            //self.activity.imageName =  [excerciseImages objectAtIndex:x];
            break;
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view.window endEditing:YES];
    self.activity.name = self.activityNameText.text;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



 - (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
     
     [self.activityNameText setText:[excerciseRoutines objectAtIndex:row]];
     //self.activity.imageName = [excerciseImages objectAtIndex:row];
}


 -(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
 
 
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [excerciseRoutines count];
}
 
 
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [excerciseRoutines objectAtIndex:row];
}


-(void)loadData
{
    excerciseRoutines = [[NSMutableArray alloc]init];
    [excerciseRoutines addObject:@"Tree"];
    [excerciseRoutines addObject:@"Triangle"];  // Triangle Pose
    [excerciseRoutines addObject:@"Mountain"];  // Mountain

    [excerciseRoutines addObject:@"Warrior I"];  // Triangle Pose
    [excerciseRoutines addObject:@"Warrior II"];  // Mountain
    
    [excerciseRoutines addObject:@"Camel"];  // Triangle Pose
    [excerciseRoutines addObject:@"Lord of Dance"];  // Mountain

    
    [excerciseRoutines addObject:@"Downward-Facing Dog"];
    [excerciseRoutines addObject:@"Ananta's"];
    [excerciseRoutines addObject:@"Crescent Moon"];
    [excerciseRoutines addObject:@"Half moon"];
    [excerciseRoutines addObject:@"Half lord of the fishes"];
    [excerciseRoutines addObject:@"Half boat posture"];
    [excerciseRoutines addObject:@"Astavarkra's"];
    [excerciseRoutines addObject:@"Bound angle"];
    [excerciseRoutines addObject:@"Crane"];
    [excerciseRoutines addObject:@"Child's"];
    [excerciseRoutines addObject:@"Bharadvaja's twist"];
    [excerciseRoutines addObject:@"Frog"];
    [excerciseRoutines addObject:@"Cobra"];
    [excerciseRoutines addObject:@"Arm-pressing posture"];
    [excerciseRoutines addObject:@"Cat Pose"];
    [excerciseRoutines addObject:@"Four-Limbed Staff"];
    [excerciseRoutines addObject:@"Staff pose"];
    [excerciseRoutines addObject:@"Bow"];
    [excerciseRoutines addObject:@"Koundiya was the name of a sage"];
    [excerciseRoutines addObject:@"One-Legged King Pigeon"];
    [excerciseRoutines addObject:@"Fetus"];
    [excerciseRoutines addObject:@"Eagle pose"];
    [excerciseRoutines addObject:@"Cow faced pose"];
    [excerciseRoutines addObject:@"Plough"];
    [excerciseRoutines sortUsingSelector:@selector(compare:)];
    
    /*
    excerciseImages = [[NSMutableArray alloc]init];
    [excerciseImages addObject:@"image-2.png"]; // Tree pose
    [excerciseImages addObject:@"image-4.png"]; // Triangle Pose
    [excerciseImages addObject:@"image-5.png"]; // Mountain
    [excerciseImages addObject:@"image-11.png"]; // Warrior I
    [excerciseImages addObject:@"image-9.png"]; // Warrior II
    [excerciseImages addObject:@"image-7.png"]; // Camel
    [excerciseImages addObject:@"image-12.png"]; // Lord of Dance
    */
    
    /*
    [excerciseImages addObject:@"image-1.png"];
    [excerciseImages addObject:@"image-3.png"];
    [excerciseImages addObject:@"image-6.png"];
    [excerciseImages addObject:@"image-7.png"];
    [excerciseImages addObject:@"image-8.png"];
    [excerciseImages addObject:@"image-10.png"];
    [excerciseImages addObject:@"image-12.png"];
    [excerciseImages addObject:@"image-1.png"];
    [excerciseImages addObject:@"image-2.png"];
    [excerciseImages addObject:@"image-3.png"];
    [excerciseImages addObject:@"image-4.png"];
    [excerciseImages addObject:@"image-5.png"];
    [excerciseImages addObject:@"image-6.png"];
    [excerciseImages addObject:@"image-8.png"];
    [excerciseImages addObject:@"image-9.png"];
    [excerciseImages addObject:@"image-10.png"];
    [excerciseImages addObject:@"image-11.png"];
    [excerciseImages addObject:@"image-1.png"];
    [excerciseImages addObject:@"image-2.png"];
    [excerciseImages addObject:@"image-3.png"];
    [excerciseImages addObject:@"image-4.png"];
    [excerciseImages addObject:@"image-5.png"];
    [excerciseImages addObject:@"image-6.png"];
    [excerciseImages addObject:@"image-7.png"];
    [excerciseImages addObject:@"image-8.png"];
    [excerciseImages addObject:@"image-9.png"];
    [excerciseImages addObject:@"image-10.png"];
    [excerciseImages addObject:@"image-11.png"];
    [excerciseImages addObject:@"image-12.png"];
    */
    
    //MASSERT(excerciseImages.count == excerciseRoutines.count);
}

@end
