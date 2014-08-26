//
//  ActivityDuration.m
//  YourYoga
//
//  Created by john on 8/25/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//

#import "ActivityDuration.h"

@interface ActivityDuration () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

static NSInteger lastDurationMin = 0;       // default duration for an excercise
static NSInteger lastDurationSec = 55;      // based on web query

@implementation ActivityDuration

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
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    if (!self.activity.durationMin || self.activity.durationMin.length <= 0){
        self.activity.durationMin = [NSString stringWithFormat:@"%ld",(long)lastDurationMin];
    }
    
    if (!self.activity.durationSec || self.activity.durationSec.length <= 0){
        self.activity.durationSec = [NSString stringWithFormat:@"%ld",(long)lastDurationSec];
    }
    
    NSInteger row;
    
    row = (NSInteger)[self.activity.durationMin integerValue];
    [self.pickerView selectRow:row inComponent:0 animated:YES];
    
    row = (NSInteger)[self.activity.durationSec integerValue];
    [self.pickerView selectRow:row inComponent:2 animated:YES];
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (component%2)?1:60; // seconds or minutes, both the same
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4; // minutes and seconds
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* rc;
    switch(component){
        case 0:
            rc = [NSString stringWithFormat:@"%ld", (long)row];
            break;
            
        case 1:
            rc = @"Min";
            break;
            
        case 2:
            rc = [NSString stringWithFormat:@"%ld", (long)row];
            break;
            
        case 3:
            rc = @"Sec";
            break;
            
    }
    return rc;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch(component)
    {
        case 0:
            lastDurationMin = row;
            [self.activity setDurationMin:[NSString stringWithFormat:@"%ld", (long)row]];
            break;
            
        case 2:
            lastDurationSec = row;
            [self.activity setDurationSec:[NSString stringWithFormat:@"%ld", (long)row]];
            break;
    }
    
}

@end
