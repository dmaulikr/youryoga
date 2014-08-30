//
//  LessonSelectionController.m
//  YourYoga
//
//  Created by john on 8/28/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "LessonSelectionController.h"
#import "SessionsManager.h"
#import "SharingEMailController.h"
#import "Utilities.h"
#import "ExportFileInfo.h"

@interface LessonSelectionController ()

@property (nonatomic, strong)SessionsManager* Manager;
@property (nonatomic, strong)NSMutableArray* Selections;

@end

@implementation LessonSelectionController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)nextClicked:(id)sender {
    SharingEMailController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"emailView"];
    vc.Export = [self buildExportFile];
    [self.navigationController pushViewController:vc animated:YES];

}




-(ExportFileInfo*)generateExportFileName
{
    //NSString* fn;
    NSInteger fnCount = 1;
    //ExportFileInfo* efi = nil;
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (!paths || paths.count < 1){
        NSAssert(paths && paths.count > 0, @"NSSearchPathForDirectoriesInDomains(NSCachesDirectory,... failed");
        return nil;
    }
    NSString* path = [paths objectAtIndex:0];
    if (!path) {
        NSAssert(path, @"NSSearchPathForDirectoriesInDomains(NSCachesDirectory,... returned no paths!");
        return nil;
    }
    

    NSString* file = nil;
    NSString* fn = nil;
    
    do {
        fn = [NSString stringWithFormat:@"Export_%ld.xml", (long)fnCount++];
        file = [path stringByAppendingPathComponent:fn];
        
    } while([[NSFileManager defaultManager] fileExistsAtPath:file]); // loop while file exists

    
    return [[ExportFileInfo alloc]initWithFilename:fn temp:file data:nil];
}


-(ExportFileInfo*)buildExportFile
{
    ExportFileInfo* efi = [self generateExportFileName];
    if (!efi) {
        return nil;
    }
    
    // Create temporary file containing exported Activities
    SessionsManager* export = [[SessionsManager alloc]initUsingFile:efi.TemporaryFile];
    
    for(int x = 0; x < self.Selections.count; ++x)
    {
        NSNumber* n = [self.Selections objectAtIndex:x];
        
        //
        // Pick only selected activities
        //
        if (n && [n boolValue]){
            
            Activities* a = [self.Manager.sessions objectAtIndex:x];
            if (a){
                [export.sessions addObject:a]; // add activity
            }
            else {
                MASSERT(a); // should never happen
            }
            
        }
    }
    
    // Save activities to temporary file
    [export saveAndNotify:NO];
    efi.ExportActivities = export;
    
    // Read into memory
    efi.Data = [[NSFileManager defaultManager] contentsAtPath:efi.TemporaryFile];

    if (!efi.Data){
        MASSERT(efi.Data);
    }
    
    return efi;
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
}

-(void)refreshView:(NSNotification*)notification
{
    [self initializeSelections];
    [self.tableView reloadData];
}

-(void)initializeSelections
{
    self.Manager = [[SessionsManager alloc]init];
    self.Selections = [[NSMutableArray alloc]initWithCapacity:self.Manager.sessions.count];
    for(int x = 0; x < self.Manager.sessions.count; ++x){
        [self.Selections setObject:[NSNumber numberWithBool:FALSE] atIndexedSubscript:x];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeSelections];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView:) name:NM_ActivitiesHaveBeenUpdated object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.Manager.sessions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    
    Activity* activity = self.Manager.sessions[indexPath.row];
    cell.textLabel.text = activity.name;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    bool selected;
    
    NSNumber* n = [self.Selections objectAtIndex:indexPath.row];
    
    if (FALSE == n.boolValue)
    {
        [self.Selections setObject:[NSNumber numberWithBool:TRUE] atIndexedSubscript:indexPath.row];
        selected = true;
    }
    else {
        [self.Selections setObject:[NSNumber numberWithBool:FALSE] atIndexedSubscript:indexPath.row];
        selected = false;
    }
    
    UITableViewCell* selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (selectedCell){
        selectedCell.accessoryType = (selected)?UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
}


@end
