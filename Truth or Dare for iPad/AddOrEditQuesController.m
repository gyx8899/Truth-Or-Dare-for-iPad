//
//  AddOrEditQuesController.m
//  Troth or Dare for iPad
//
//  Created by 015 YQ on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddOrEditQuesController.h"

@implementation UINavigationBar (CustomImage)   
- (void)drawRect:(CGRect)rect {   
    UIImage *image = [UIImage imageNamed: @"add_nav_bg_ipad.png"];   
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
}

@end

@interface AddOrEditQuesController ()

@end

@implementation AddOrEditQuesController

@synthesize navgationBar;
@synthesize navgationItem;
@synthesize textView;
@synthesize myTextView;
@synthesize content;
@synthesize id;
@synthesize type;


#pragma mark - button Methods

-(IBAction)cancelBtnPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)saveBtnPressed:(id)sender
{
    //Save truth or dare question of user add or edit.
    SQLite3Util *sqlUtil = [[SQLite3Util alloc] init];
    NSString *sql = [[[NSString alloc] init] autorelease];
    NSString *msg = [[[NSString alloc] init] autorelease];
    switch (type) {
        case 1://Add truth
            sql = [NSString stringWithFormat:@"INSERT INTO TruthorDare(content, TOrD, id) values('%@', '%@', %d)", self.myTextView.text, @"truth", [sqlUtil getCountOfDB] + 1];
            msg = @"Truth cannot be empty.";
            break;
        case 2://Add dare
            sql = [NSString stringWithFormat:@"INSERT INTO TruthorDare(content, TOrD, id) values('%@', '%@', %d)", self.myTextView.text, @"dare", [sqlUtil getCountOfDB] + 1];
            msg = @"Dare cannot be empty.";
            break;
        case 3://Edit truth
            sql = [NSString stringWithFormat:@"REPLACE INTO TruthorDare(content, TOrD, id) values('%@', '%@', %d)", self.myTextView.text, @"truth", self.id];
            msg = @"Truth cannot be empty.";
            break;
        case 4://Edit dare
            sql = [NSString stringWithFormat:@"REPLACE INTO TruthorDare(content, TOrD, id) values('%@', '%@', %d)", self.myTextView.text, @"dare", self.id];
            msg = @"Dare cannot be empty.";
            break;
        default:
            break;
    }
    if ([self.myTextView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else{
        if ([sqlUtil insertOrUpdateTruthOrDare:sql]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
        }
    }
    [self dismissModalViewControllerAnimated:YES];
    [sqlUtil release]; 
}


#pragma mark - view lifeCycle

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
	// Do any additional setup after loading the view.
    
    if ([self.navgationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navgationBar setBackgroundImage:[UIImage imageNamed:@"add_nav_bg_ipad.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
    titleLabel.font = [UIFont boldSystemFontOfSize:30];
    titleLabel.textColor = [UIColor yellowColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    titleLabel.textAlignment = UITextAlignmentCenter;
    switch (self.type) {
        case 1:
            titleLabel.text = @"Add Truth";
            break;
        case 2:
            titleLabel.text = @"Add Dare";
            break;
        case 3:
            titleLabel.text = @"Edit Truth";
            break;
        case 4:
            titleLabel.text = @"Edit Dare";
            break;
        default:
            break;
    }
    self.navgationItem.titleView = titleLabel;
    [titleLabel release];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 5, 35, 35);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_cancel_ipad.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navgationItem.leftBarButtonItem = cancelBtn;
    [cancelBtn release];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(10, 5, 35, 35);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_save_ipad.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navgationItem.rightBarButtonItem = saveBtn;
    [saveBtn release];
    
    self.textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"smalltextview_bg_ipad.png"]];
    self.myTextView.text = self.content;
    [self.myTextView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setNavgationItem:nil];
    [self setTextView:nil];
    [self setContent:nil];
    [self setNavgationBar:nil];
    [self setMyTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationPortrait == interfaceOrientation)||(UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation);
}

- (void)dealloc {
    [navgationItem release];
    [textView release];
    [content release];
    [navgationBar release];
    [myTextView release];
    [super dealloc];
}
@end
