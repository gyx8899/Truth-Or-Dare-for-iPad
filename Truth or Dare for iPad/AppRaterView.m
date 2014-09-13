//
//  AppRaterView.m
//  Period Planner
//
//  Created by SL02 on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppRaterView.h"
#import "Appirater.h"

@implementation AppRaterView
@synthesize titleImage;
@synthesize rateBtn;
@synthesize laterBtn;
@synthesize thankBtn;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}
-(IBAction)BtnPressed:(id)sender
{
	UIButton * btn = (UIButton *)sender;
	if(btn.tag == 0)
	{	
		[Appirater BtnPressed:0];
	}
	else if(btn.tag == 1)
	{	
	}
	else 
	{
		[Appirater BtnPressed:2];
	}
    [self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        return (UIInterfaceOrientationPortrait == interfaceOrientation)||(UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation);
}

- (void)dealloc {
	[rateBtn release];
	[laterBtn release];
	[thankBtn release];
	[titleImage release];
    [super dealloc];
}


@end
