//
//  MoreController.m
//  YourYoga
//
//  Created by john on 8/20/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "MoreController.h"
#import "MoreItem.h"
#import "Utilities.h"


@interface MoreController ()

@property (nonatomic, strong)NSMutableArray* items;

@end

//
// Example for how More item might be implemented
//


@implementation MoreController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString*)loadBuildInfo
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *label = [NSString stringWithFormat:@"%@ v%@ (build %@)", name, version, build];
    return label;
}



-(void)loadData
{
    MoreItem* mi;

    
    mi = [[MoreItem alloc]initWithTitle:@"Support" description:[NSString stringWithFormat:@"[App Version %@]", [self loadBuildInfo]] url:@"http://saintsoftware.blogspot.com/search/label/youryoga"];
    [self.items addObject:mi];
    
    
    mi = [[MoreItem alloc]initWithTitle:@"Yoga Anonymous" description:@"An open platform that allows teachers, studios, event promoters, and bloggers a place to interact with the community at large" url:@"http://yoganonymous.com/"];
    [self.items addObject:mi];
    
    mi = [[MoreItem alloc]initWithTitle:@"Yoga Journal" description:@"Web Magazine covering, you guested it..." url:@"http://www.yogajournal.com/"];
    [self.items addObject:mi];
    mi = [[MoreItem alloc]initWithTitle:@"NWC Yoga" description:@"Northwest Corporate Yoga" url:@"http://awakenedyoga83.wordpress.com/"];
    [self.items addObject:mi];
    
    mi = [[MoreItem alloc]initWithTitle:@"MindBodyGreen" description:@"Wellness with an interesting twist" url:@"http://www.mindbodygreen.com/"];
    [self.items addObject:mi];
    
    mi = [[MoreItem alloc]initWithTitle:@"GAIAM life" description:@"Your guide to better living" url:@"http://life.gaiam.com/"];
    [self.items addObject:mi];
    
    mi = [[MoreItem alloc]initWithTitle:@"Whole living" description:@"body + soul in balance" url:@"http://www.wholeliving.com/"];
    [self.items addObject:mi];
    
    mi = [[MoreItem alloc]initWithTitle:@"YogaDork" description:@"Yoga from a dork" url:@"http://yogadork.com/"];
    [self.items addObject:mi];
    
}


- (void)viewDidLoad
{
    @try {
        [super viewDidLoad];
        self.items = [[NSMutableArray alloc]init];
        [self loadData];
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    @try {
        cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell" forIndexPath:indexPath];
        if(cell){
            MoreItem* mi = self.items[indexPath.row];
            if (mi){
                cell.textLabel.text = mi.title;
                cell.detailTextLabel.text = mi.description;
            }
            else {
                MASSERT(mi);
            }
        }
        else {
            MASSERT(cell);
            cell = [Utilities errorCell];
        }
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
        cell = [Utilities errorCell];
        cell.detailTextLabel.text = exception.description;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    @try {
        MoreItem* mi = [self.items objectAtIndex:indexPath.row];
        if (mi){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mi.url]];
        }
        else {
            MASSERT(mi);
        }
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
    
}
@end
