//
//  QuestionViewController.m
//  Troth or Dare for iPad
//
//  Created by 015 YQ on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionViewController.h"
#import "AddOrEditQuesController.h"
#import "QuestionCustomCell.h"
#import "ViewController.h"

@implementation UINavigationBar (CustomImage)   
- (void)drawRect:(CGRect)rect {   
    UIImage *image = [UIImage imageNamed: @"nav_bg_ipad.png"];   
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
}
@end

@interface QuestionViewController ()

@end

@implementation QuestionViewController

@synthesize truthOrDare;
@synthesize qusetionTableView;
@synthesize truthArray;
@synthesize dareArray;
@synthesize listData;
@synthesize actionSheet;
@synthesize questionType;
@synthesize dismiss;

- (IBAction)homeBtnPressed:(id)sender
{
    
    if ([self.actionSheet isVisible]) {
        [self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:YES];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)addBtnPressed:(id)sender
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Truth",@"Add Dare", nil];
    [self.actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
}

- (IBAction)switchTruthOrDare:(UISegmentedControl *)segmentedControl
{
    NSInteger index = segmentedControl.selectedSegmentIndex;
    if (index == 0) {
        [self.truthOrDare setImage:[UIImage imageNamed:@"btn_truth_unselect_ipad.png"] forSegmentIndex:0];
        [self.truthOrDare setImage:[UIImage imageNamed:@"btn_dare_select_ipad.png"] forSegmentIndex:1];
        self.listData = self.truthArray;
        [self.qusetionTableView reloadData];
    }
    else {
        [self.truthOrDare setImage:[UIImage imageNamed:@"btn_truth_select_ipad.png"] forSegmentIndex:0];
        [self.truthOrDare setImage:[UIImage imageNamed:@"btn_dare_unselect_ipad.png"] forSegmentIndex:1];
        self.listData = self.dareArray;
        [self.qusetionTableView reloadData];
    }
    if ([self.actionSheet isVisible]) {
        [self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:YES];
    }
}

- (void)refresh:(NSNotification *)notification
{
    self.truthOrDare.hidden = NO;
    SQLite3Util *sqlUtil = [[SQLite3Util alloc] init];
    if (questionType == 1 || questionType == 3) {
        self.truthOrDare.selectedSegmentIndex = 0;
        self.truthArray = [sqlUtil getTruthOrDares:YES];
        self.listData = self.truthArray;
    }else {
        self.truthOrDare.selectedSegmentIndex = 1;
        self.dareArray = [sqlUtil getTruthOrDares:NO];
        self.listData = self.dareArray;
    }
    [self.qusetionTableView reloadData];
    [sqlUtil release];
}

#pragma mark - view lifeCycle

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

    // Set nav's background image
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_ipad.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    // Set nav title and left right button
    self.truthOrDare = [[BSSegmentedControl alloc] init];
    NSArray *array = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"btn_truth_unselect_ipad.png"],[UIImage imageNamed:@"btn_dare_select_ipad.png"], nil];
    [self.truthOrDare initWithItems:array];
    [self.truthOrDare setSelectedSegmentIndex:0];
    [self.truthOrDare addTarget:self action:@selector(switchTruthOrDare:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.truthOrDare;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 5, 35, 35);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_home_ipad.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(homeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = homeBtn;
    [homeBtn release];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(10, 5, 35, 35);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_ipad.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = addBtn;
    [addBtn release];
    
    // Set view background
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg_ipad.png"]];
    self.tableView.backgroundView = view;
    
    SQLite3Util *sqlUtil = [[SQLite3Util alloc] init];
    self.truthArray = [sqlUtil getTruthOrDares:YES];
    self.dareArray = [sqlUtil getTruthOrDares:NO];
    self.listData = self.truthArray;
    [sqlUtil release];
    
    // Set notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"refresh" object:nil];
    
    self.dismiss = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.truthOrDare = nil;
    self.qusetionTableView = nil;
    self.truthArray = nil;
    self.dareArray = nil;
    self.listData = nil;
    self.actionSheet = nil;
}

- (void)dealloc
{
    [truthOrDare release];
    [qusetionTableView release];
    [truthArray release];
    [dareArray release];
    [listData release];
    [actionSheet release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationPortrait == interfaceOrientation)||(UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *truthCellIdentifier = @"TruthCellIdentifier";
    static NSString *dareCellIdentifier  = @"DareCellIdentifier";
    QuestionCustomCell *cell = [[QuestionCustomCell alloc] init];
    if (self.truthOrDare.selectedSegmentIndex == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:truthCellIdentifier];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:dareCellIdentifier];
    }
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QuestionCustomCell" owner:self options:nil];
        if ([[nib objectAtIndex:0] isKindOfClass:[QuestionCustomCell class]]) {
            cell = [nib objectAtIndex:0];
        }
    }
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg_ipad.png"]];
    [cell setBackgroundView:background];
    [background release];
    [cell.textLabel setFont:[UIFont systemFontOfSize:28]];
    [cell.textLabel setNumberOfLines:2];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSInteger row = [indexPath section];
    Question *question = [self.listData objectAtIndex:row];
    cell.textLabel.text = question.content;
    cell.textLabel.textColor = [UIColor colorWithRed:61/255.0 green:46/255.0 blue:11/255.0 alpha:1.0];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = [indexPath section];
        Question *question = [self.listData objectAtIndex: row];
        SQLite3Util *sqlUtil = [[SQLite3Util alloc] init];
        [sqlUtil deleteQuestion:[NSString stringWithFormat:@"DELETE FROM TruthorDare WHERE id=%d",question.id]];
        if (self.truthOrDare.selectedSegmentIndex == 1) {
            [self.dareArray removeObjectAtIndex:row];
            self.listData = self.dareArray;
        }else {
            [self.truthArray removeObjectAtIndex:row];
            self.listData = self.truthArray;
        }
        [sqlUtil release];
        [self.qusetionTableView deleteSections:[NSIndexSet indexSetWithIndex: row] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.listData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 97;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath section];
    Question *question = [self.listData objectAtIndex:row];
    AddOrEditQuesController *editTrueOrDare = [[[AddOrEditQuesController alloc] initWithNibName:@"AddOrEditQuesController" bundle:nil] autorelease];
    if (self.truthOrDare.selectedSegmentIndex == 0) {
        self.questionType = editTrueOrDare.type = 3;
    }else {
        self.questionType = editTrueOrDare.type = 4;
    }
    editTrueOrDare.content = question.content;
    editTrueOrDare.id = question.id;
    editTrueOrDare.modalPresentationStyle = UIModalPresentationFormSheet;
    editTrueOrDare.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:editTrueOrDare animated:YES];
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AddOrEditQuesController *addTrueOrDare = [[[AddOrEditQuesController alloc] initWithNibName:@"AddOrEditQuesController" bundle:nil] autorelease];
    addTrueOrDare.content = @"";
    addTrueOrDare.modalInPopover = YES;
    addTrueOrDare.modalPresentationStyle = UIModalPresentationFormSheet;
    if (buttonIndex == 0) {
        self.questionType = addTrueOrDare.type = 1;
        self.dismiss = NO;
        [self presentModalViewController:addTrueOrDare animated:YES];
    }else if(buttonIndex ==1) {
        self.questionType = addTrueOrDare.type = 2;
        self.dismiss = NO;
        [self presentModalViewController:addTrueOrDare animated:YES];
    }
}

@end
