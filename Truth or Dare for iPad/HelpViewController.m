//
//  HelpViewController.m
//  Troth or Dare for iPad
//
//  Created by 015 YQ on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"

#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>

@implementation UINavigationBar (CustomImage)   
- (void)drawRect:(CGRect)rect {   
    UIImage *image = [UIImage imageNamed: @"nav_bg_ipad.png"];   
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
}
@end

@interface HelpViewController ()

@end

@implementation HelpViewController


- (IBAction)homeBtnPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)contactBtnPressed:(id)sender {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Set view backgroud image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg_ipad.png"]];
    
    // Set nav backgroud and left (back) button
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_ipad.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 5, 35, 35);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_home_ipad.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(homeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = homeBtn;
    [homeBtn release];
    
    // Set nav title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 200, 32)];
    titleLabel.font = [UIFont boldSystemFontOfSize:28];
    titleLabel.textColor = [UIColor yellowColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = @"Help";
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationPortrait == interfaceOrientation)||(UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation);
}

#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    [picker setSubject:@"Pocket Truth or Dare for iPad Support"];
    
    // Custom NavgationBar background
    picker.navigationBar.tintColor = [UIColor colorWithRed:209.0/255 green:183.0/255 blue:126.0/255 alpha:1.0];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_ipad.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"maxwellsoftware@gmail.com"]; 
	
	[picker setToRecipients:toRecipients];
	
	// Fill out the email body text
    struct utsname device_info;
    uname(&device_info);
    NSString *emailBody = [NSString 
                           stringWithFormat:@"Model: %s\nVersion: %@\nApp: %@\nFeedback here:\n",device_info.machine, 
                           [[UIDevice currentDevice] systemVersion],
                           [[[NSBundle mainBundle] infoDictionary]
                            objectForKey:@"CFBundleShortVersionString"]];
    
	[picker setMessageBody:emailBody isHTML:NO];
    
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg   
{  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_   
                                                    message:msg   
                                                   delegate:nil   
                                          cancelButtonTitle:@"Sure"   
                                          otherButtonTitles:nil];  
    [alert show];  
    [alert release];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark - UIAlertView 

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:maxwellsoftware@gmail.com&subject=Pocket Truth or Dare Support";
	NSString *body = @"&body=email body!";
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


@end
