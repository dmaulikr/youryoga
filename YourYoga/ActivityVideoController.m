//
//  ActivityVideoController.m
//  YourYoga
//
//  Created by john on 8/29/14.
//  Copyright (c) 2014 SaintsSoft LLC. All rights reserved.
//
#import "ActivityVideoController.h"
#import "Utilities.h"


@interface ActivityVideoController () <UIWebViewDelegate>

@end

@implementation ActivityVideoController


-(void)updateVideoUrl
{
    @try {
        if (self.activity){
            self.activity.videoURL = self.videoUrlCell.textField.text;
        }
        if (self.videoUrlCell){
            NSURL* url = [NSURL URLWithString:self.activity.videoURL];
            NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url];
            [self.webView loadRequest:request];
        }
        
    }
    @catch (NSException *exception) {
        [Utilities logException:exception faultSelector:_cmd];
    }
}


- (IBAction)didEndOnExit:(id)sender {
    [sender resignFirstResponder];
    [self updateVideoUrl];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

static NSString* lastUrl = @"http://www.youtube.com";

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.webView){
        self.webView.delegate = self;
    }
    if (self.activity){
        self.videoUrlCell.textField.text = (self.activity.videoURL)?self.activity.videoURL:lastUrl;
        [self updateVideoUrl];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view.window endEditing:YES];
    
    if (self.activity){
        self.activity.videoURL = self.videoUrlCell.textField.text;
    }
    else {
        MASSERT(self.activity);
    }
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Type %ld  URL:%@", (long)navigationType, [request.URL absoluteString]);
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        if (self.videoUrlCell)
        {
            self.videoUrlCell.textField.text = [request.URL absoluteString];
            if (self.activity){
                self.activity.videoURL = self.videoUrlCell.textField.text;
            }
            
        }
    }
    return YES;
}


@end
