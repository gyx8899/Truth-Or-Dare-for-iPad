//
//  ViewController.m
//  Troth or Dare for iPad
//
//  Created by 015 YQ on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "HelpViewController.h"
#import "QuestionViewController.h"
#import "Appirater.h"

@implementation UINavigationBar (CustomImage)   
- (void)drawRect:(CGRect)rect {   
    UIImage *image = [UIImage imageNamed: @"nav_bg_ipad.png"];   
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
}
@end

//Override UITextField to move down the textRect against the bottom.
@interface MYTextField : UITextField
@end

@implementation MYTextField

//Move down textRect and lessen the width
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x, bounds.origin.y + 3, bounds.size.width , bounds.size.height);
}
//Set bounds of editRect
-(CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 8, bounds.origin.y + 3, bounds.size.width - 15, bounds.size.height);
}
@end


@interface ViewController ()

@end

@implementation ViewController

@synthesize pickerView;
@synthesize scrollView;
@synthesize nullBtn;
@synthesize playBtn;
@synthesize nextBtn;
@synthesize hiddenBtn;
@synthesize numPlayers;
@synthesize selectBg;
@synthesize audioPlayer;
@synthesize senderBtn;
@synthesize defaultName;
@synthesize popoverController;
@synthesize timer;
@synthesize playerId;
@synthesize accelerometer;
@synthesize isCanShake;

#pragma mark - Button pressed

- (IBAction)questionBtnPressed:(id)sender
{
    QuestionViewController *questionVC = [[QuestionViewController alloc] initWithNibName:@"QuestionViewController" bundle:nil];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:questionVC] autorelease];
    [self presentModalViewController:nav animated:YES];
    [questionVC release];
}

- (IBAction)helpBtnPressed:(id)sender
{
    HelpViewController *helpVC = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:helpVC] autorelease];
    [self presentModalViewController:nav animated:YES];
    [helpVC release];
}

// HiddenBtn's action of touch up inside 
- (IBAction)hiddenPressed:(id)sender 
{
    if (!self.hiddenBtn.hidden) {
        self.hiddenBtn.hidden = YES;
        [self.hiddenBtn setHighlighted:YES];
        
        //If keyboard is available,resign it.
        [self.view endEditing:YES];
        
        [UIView beginAnimations:@"Hidden" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [self.hiddenBtn setCenter:CGPointMake(self.hiddenBtn.center.x, 94)];
        self.scrollView.frame = CGRectMake(0, 25, 768, 663);
        [self.scrollView setCenter:CGPointMake(self.scrollView.center.x, self.scrollView.center.y+90)];
        [self.pickerView setCenter:CGPointMake(self.pickerView.center.x, -self.pickerView.center.y)];
        [UIView commitAnimations];
    }
}

// HiddenBtn's action of drag down
- (IBAction)hiddenDrag:(id)sender
{
    if (!self.hiddenBtn.hidden) {
        self.hiddenBtn.hidden = YES;
        [self.hiddenBtn setHighlighted:YES];
        
        //If keyboard is available,resign it.
        [self.view endEditing:YES];
        
        [UIView beginAnimations:@"Hidden Down" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [self.hiddenBtn setCenter:CGPointMake(self.hiddenBtn.center.x, 94)];
        self.scrollView.frame = CGRectMake(0, 25, 768, 663);
        [self.scrollView setCenter:CGPointMake(self.scrollView.center.x, self.scrollView.center.y+90)];
        [self.pickerView setCenter:CGPointMake(self.pickerView.center.x, -self.pickerView.center.y)];
        [UIView commitAnimations];
    }
}

- (IBAction)playerPressed:(id)sender
{
    //If keyboard is available,resign it.
    [self.view endEditing:YES];
    
    //Prevent playBtn have pressed,ActionSheet or Take Photo or Choose Photo abnormal.
    if (self.playBtn.hidden == NO) {
        
        //Show all players, when the player or player name is pressed.
        [self showAllPlayers];
        
        //Select the button's player
        self.senderBtn = (UIButton *)sender;
        UIView *playerView = senderBtn.superview;
        [self.selectBg setCenter:CGPointMake(playerView.center.x, playerView.center.y)];
        
        //Set the ActionSheet show From Rect-selectRect
        CGRect selectRect;
        if (self.scrollView.contentOffset.y > 0) {
            selectRect = CGRectMake(self.selectBg.frame.origin.x, self.selectBg.frame.origin.y - self.scrollView.contentOffset.y, self.selectBg.frame.size.width, self.selectBg.frame.size.height);
        }else {
            selectRect = self.selectBg.frame;
        }
        //Create an ActionSheet and waiting user to select image for player
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //Camera is available
            UIActionSheet *playerIconSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo", nil];
            [playerIconSheet showFromRect:selectRect inView:self.view animated:YES];
            [playerIconSheet release];
        }else {
            //Camera is not available
            UIActionSheet *playerIconSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Photo", nil];
            [playerIconSheet showFromRect:selectRect inView:self.view animated:YES];
            [playerIconSheet release];
        }
    }
}

- (IBAction)nextBtnPressed:(id)sender
{
    //Stop timer
    [self.timer invalidate];
    
    //Stop audoPlayer
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        [self.audioPlayer setCurrentTime:0];
    }
    
    //Set and enter the playerViewController
    PlayerViewController *playVC = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    UIView *player = [self.scrollView.subviews objectAtIndex:self.playerId];
    UIButton *btn = [player.subviews objectAtIndex:0];
    playVC.icon = btn.imageView.image;
    
    MYTextField *playerName = [player.subviews objectAtIndex:2];
    playVC.playerName = playerName.text;
    
    [self.navigationController pushViewController:playVC animated:YES];
}

- (IBAction)shakeOrPlay:(id)sender {
    self.isCanShake = NO;
    self.playBtn.enabled = NO;
    self.nextBtn.enabled = NO;
    
    if (self.hiddenBtn.isHidden) {
        [NSThread detachNewThreadSelector:@selector(showAllPlayers) toTarget:self withObject:nil];
        [NSThread sleepForTimeInterval:0.3];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(nextBtnPressed:) userInfo:nil repeats:NO];
    self.playerId = [self selectPlayer];
    
    self.nextBtn.hidden  = NO;
    self.nextBtn.enabled = YES;
    self.playBtn.hidden  = YES;
    self.playBtn.enabled = NO;
}

#pragma mark - Other Methods


//Hid the hiddenBtn to show all players
- (void)showAllPlayers
{
    if ([self.hiddenBtn isHidden]) {
        @autoreleasepool {
            [UIView animateWithDuration:0.3 animations:^(void){
                //Hide the pickerView , self.pickerView.center.y = 80.0 
                [self.pickerView setCenter:CGPointMake(self.pickerView.center.x, -80.0)];
                
                //Popup hiddenButton
                self.hiddenBtn.hidden = NO;
                [self.hiddenBtn setCenter:CGPointMake(self.hiddenBtn.center.x, 20)];
                
                //scrollView move up (reduce y 10 and add height 85). 
                //Point out :self.scrollView.frame.size.height = 658,self.scrollView.frame.origin.y = 126.0
                self.scrollView.frame = CGRectMake(0, 126.0-10, 768, 663+80);
                
                //Point out :self.scrollView.center.y = 487.5.0
                [self.scrollView setCenter:CGPointMake(self.scrollView.center.x, 487.5-80)];
            }];
        }
    }
}

- (void)adjustScrollViewHeight
{
    //Scroll View的高度应根据所选择玩家数量动态调整
    int index = [self.pickerView getIndex];
    //numPlayerOfOneRow : 5;
    int rowOfScroolView = index%5 ? index/5+1 : index/5;
    [self.scrollView setContentSize:CGSizeMake(768, 20+rowOfScroolView*190)];
    [self.scrollView reloadInputViews];
}

- (void)drawPlayer:(UIView *)player index:(int )index
{
    // Set player's tag
    player.tag = index;
    
    // Set player's Icon 
    UIButton *player_icon = [UIButton buttonWithType:UIButtonTypeCustom];
    player_icon.frame = CGRectMake(5, 5, 110, 110);
    [player_icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"photo_%d",index]] forState:UIControlStateNormal];
    [player_icon addTarget:self action:@selector(playerPressed:) forControlEvents:UIControlEventTouchUpInside];
    [player insertSubview:player_icon atIndex:0];
    
    // Set player's background image
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_bg_ipad.png"]];
    [player insertSubview:background atIndex:1];
    [background release];
    
    // Set player's name
    MYTextField *textName = [[MYTextField alloc] initWithFrame:CGRectMake(0, 127, 120, 44)];
    [textName setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"name_bg_ipad.png"]]];
    [textName setOpaque:NO];
    [textName setReturnKeyType:UIReturnKeyDone];
    textName.textAlignment = UITextAlignmentCenter;
    textName.font = [UIFont systemFontOfSize:23];
    textName.textColor = [UIColor blackColor];
    textName.text = [NSString stringWithFormat:@"Player %d",index];
    [textName addTarget:self action:@selector(textFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [textName addTarget:self action:@selector(textFieldEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [player insertSubview:textName atIndex:2];
    [textName release];
    
    
    //判断是否在index处，再add player
    if (numPlayers == index) {
        [self.scrollView insertSubview:player atIndex:index-1];
        numPlayers = numPlayers + 1;
    }
    [self adjustScrollViewHeight];
}

- (IBAction)textFieldBegin:(id)sender
{
    //Show all players, when the player or player name is pressed.
    [self showAllPlayers];
    
    MYTextField *playerName = (MYTextField *)sender;
    UIView *playerView = playerName.superview;
    @autoreleasepool {
        [UIView animateWithDuration:0.3 animations:^(void){
            //Select the textField's Player
            [self.selectBg setCenter:CGPointMake(playerView.center.x, playerView.center.y)];
            
            //Now numPlayers != pickerView.getIndex ,but numPlayers + 1 = pickerView.getIndex.
            int rowNumberPlayer = ((numPlayers-1)%5) ? ((numPlayers-1)/5 + 1) :((numPlayers-1)/5);
            int rowSelectPlayer = (playerView.tag%5) ? (playerView.tag/5 + 1) :(playerView.tag/5);
            
            //Set scrollView slide
            if (rowNumberPlayer == rowSelectPlayer && rowNumberPlayer > 3) {
                //ScrollView move up,so the height reduce 80.
                self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, 743 - 80);//self.scrollView.frame.size.height = 743
            }
        }];
    }
    self.defaultName = playerName.text;
}

- (IBAction)textFieldEnd:(id)sender
{
    MYTextField *playerName = (MYTextField *)sender;
    @autoreleasepool {
        [UIView animateWithDuration:0.3 animations:^(void){
            if (self.scrollView.frame.size.height == 743-80) {
                //ScrollView renew to height = 743.
                self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, 743);//self.scrollView.frame.size.height = 743
            }
        }];
    }
    if ([playerName.text isEqualToString:@""]) {
        playerName.text = self.defaultName;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note" message:@"Player name cannot be empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else {
        [sender resignFirstResponder];
    }
}

- (void)playMusic
{
    if (![audioPlayer isPlaying]) {
        [audioPlayer play];
    }
}

- (void)playAnimation:(UIView *)player
{
    @autoreleasepool {
        [UIView animateWithDuration:0.3 animations:^(void){
            [self.selectBg setCenter:CGPointMake(player.center.x, player.center.y)];
            
            //Auto scroll to the selected player
            if (fabs(self.scrollView.contentOffset.y - player.center.y) > 30) {
                if (player.center.y > 150) {
                    [self.scrollView setContentOffset:CGPointMake(0, self.selectBg.center.y - 150)];
                }else{
                    [self.scrollView setContentOffset:CGPointMake(0, self.selectBg.center.y - 106)]; 
                }
            }
        }];
    }
}

- (int)selectPlayer
{
    [self playMusic];
    self.nullBtn.hidden = NO;
//    self.hiddenBtn.enabled = NO;
    int countPlayer = self.pickerView.getIndex;
    int selectedPlayer;
    
    for (int i = 0; i < 15; i++) {
        int index = arc4random()%countPlayer + 1;
        UIView *player = [self.scrollView.subviews objectAtIndex:index - 1];
        [NSThread detachNewThreadSelector:@selector(playAnimation:) toTarget:self withObject:player];
        if (i < 14) {
            [NSThread sleepForTimeInterval:0.3];
        }
        if (i == 14) {
            selectedPlayer = index - 1;
        }
    }
//    self.nullBtn.hidden = YES;
    return selectedPlayer;
}

- (void)showAlert:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)showAlertView:(NSNotification *)notification
{
    if (self.pickerView.getIndex <= 2) {
        [self showAlert:@"Number of players has reached its minimum."];
    }else if (self.pickerView.getIndex >= 50) {
        [self showAlert:@"Number of players has reached its maximum."];
    }
}

//Get a picture by camera or photo library
- (void)getPicture:(UIImagePickerControllerSourceType)type
{
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        pickerImage.sourceType = type;
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:pickerImage];
        self.popoverController = popover;
        
        //Set the popoverController show From Rect-selectRect
        CGRect selectRect;
        if (self.scrollView.contentOffset.y > 0) {
            selectRect = CGRectMake(self.selectBg.frame.origin.x, self.selectBg.frame.origin.y - self.scrollView.contentOffset.y, self.selectBg.frame.size.width, self.selectBg.frame.size.height);
        }else {
            selectRect = self.selectBg.frame;
        }
        [popoverController presentPopoverFromRect:selectRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        [popover release];
        [pickerImage release];
    }
}

- (void)showPlayOrShakeBtn:(NSNotification *)notification
{
    self.hiddenBtn.enabled = YES;
//    self.nextBtn.hidden    = YES;
//    self.nextBtn.enabled   = NO;
//    self.playBtn.hidden    = NO;
//    self.playBtn.enabled   = YES;
}

- (void)shakeDevice:(NSNotification *)notification
{
    if (self.isCanShake) {
        self.isCanShake = NO;
        self.playBtn.enabled = NO;
        self.nextBtn.enabled = NO;
        
        if ([self.hiddenBtn isHidden]) {
            [NSThread detachNewThreadSelector:@selector(showAllPlayers) toTarget:self withObject:nil];
            [NSThread sleepForTimeInterval:0.3];
        }else {
            [self.view endEditing:YES];
        }
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(nextBtnPressed:) userInfo:nil repeats:NO];
        self.playerId = [self selectPlayer];
        
        self.nextBtn.hidden  = NO;
        self.nextBtn.enabled = YES;
        self.playBtn.hidden  = YES;
        self.playBtn.enabled = NO;
    }
}

- (void) invalidateTimer 
{ 
    if (self.timer) 
    { 
        [self.timer invalidate]; 
        self.timer = nil; 
    } 
}

- (void)pressButton
{
    
}

- (void)hideNulBtn:(NSNotification *)notification
{
    self.nullBtn.hidden = YES;
}

- (void)displayNulBtn:(NSNotification *)notification
{
    self.nullBtn.hidden = NO;
}

#pragma mark - Add or remove players

- (IBAction)leftBtnPressed:(id)sender
{
    [self removePlayer];
}

- (IBAction)rightBtnPressed:(id)sender
{
    [self addPlayer];
}

//Add player
- (void)addPlayer
{
    int centerX = self.pickerView.playerPicker.contentOffset.x + 74;//
    int centerY = self.pickerView.playerPicker.contentOffset.y;
    if (centerX < 74*49) {
        //Selected index's color changed.
        int index = self.pickerView.playerPicker.contentOffset.x/74;
        UILabel *label1 = [self.pickerView.playerPicker.subviews objectAtIndex:index+4];
        label1.textColor = [UIColor colorWithRed:7/255.0 green:53/255.0 blue:69/255.0 alpha:1.0];
        UILabel *label2 = [self.pickerView.playerPicker.subviews objectAtIndex:index+5];
        label2.textColor = [UIColor colorWithRed:220/255.0 green:255/255.0 blue:142/255.0 alpha:1.0];
        
        //Add and draw player
        [self.pickerView.playerPicker setContentOffset:CGPointMake(centerX, centerY)];
        int countOfPlayer = [self.pickerView getIndex];
        int column = countOfPlayer%5 ? countOfPlayer%5 : 5;
        int row = (column == 5) ? countOfPlayer/5 : countOfPlayer/5+1;
        UIView *player = [[UIView alloc] initWithFrame:CGRectMake(28 + (28+120)*(column-1), 20+190*(row-1), 120, 172)];
        @autoreleasepool {
            [UIView animateWithDuration:0.7 animations:^(void){
                [self drawPlayer:player index:countOfPlayer];
            }];
        }
    }else {
        [self showAlert:@"Number of players has reached its maximum."];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNulBtn" object:nil];
}

//Add multi players
- (void)addMultiPlayer:(NSNotification *)notification
{
    int playerCount = [self.pickerView getIndex];
    for (int i = 1 ; i <= self.pickerView.temp; i++) {
        int playerIndex = playerCount - self.pickerView.temp + i;
        int column = playerIndex%5 ? playerIndex%5 : 5;
        int row = (playerIndex%5 == 0) ? playerIndex/5 :playerIndex/5+1;
        UIView *player = [[UIView alloc] initWithFrame:CGRectMake(28 + (28+120)*(column-1), 20+190*(row-1), 120, 172)];
        @autoreleasepool {
            [UIView animateWithDuration:0.7 animations:^(void){
                [self drawPlayer:player index:playerIndex];
            }];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNulBtn" object:nil];
}

//Remove player
- (void)removePlayer
{
    int centerX = self.pickerView.playerPicker.contentOffset.x - 74;
    int centerY = self.pickerView.playerPicker.contentOffset.y ;
    if (centerX >= 0) {
        //Selected index's color changed.
        int index = self.pickerView.playerPicker.contentOffset.x/74;
        UILabel *label1 = [self.pickerView.playerPicker.subviews objectAtIndex:index+4];
        label1.textColor = [UIColor colorWithRed:7/255.0 green:53/255.0 blue:69/255.0 alpha:1.0];
        UILabel *label2 = [self.pickerView.playerPicker.subviews objectAtIndex:index+3];
        label2.textColor = [UIColor colorWithRed:220/255.0 green:255/255.0 blue:142/255.0 alpha:1.0];
        
        //Remove method.
        [self.pickerView.playerPicker setContentOffset:CGPointMake(centerX, centerY)];
        [[self.scrollView.subviews objectAtIndex:[self.pickerView getIndex]]removeFromSuperview];
        numPlayers = numPlayers - 1;
    }else {
        [self showAlert:@"Number of players has reached its minimum."];
    }
    //调整ScrollView时，select背景框选择默认的Player2
    [self.selectBg setCenter:CGPointMake(235.5, 105)];
    
    [self adjustScrollViewHeight];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNulBtn" object:nil];
}

//Remove multi players
- (void)removeMultiPlayer:(NSNotification *)notification
{
    int countPlayer = [self.pickerView getIndex];
    int temp = -self.pickerView.temp;
    for (int i = 1 ; i <= temp; i++) {
        int playerIndex = countPlayer + temp - i;
        [[self.scrollView.subviews objectAtIndex:playerIndex] removeFromSuperview];
        numPlayers = numPlayers - 1;
    }
    //调整ScrollView时，select背景框选择默认的Player2
    [self.selectBg setCenter:CGPointMake(235.5, 105)];
    
    [self adjustScrollViewHeight];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNulBtn" object:nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set title and background images
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_title_ipad.png"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg_ipad.png"]];
    
    // Set ScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 119, 768, 660)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = NO;
    self.scrollView.scrollsToTop = NO;
    [self.scrollView setContentSize:CGSizeMake(768, 210)];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.scrollView];
    
    // Add picker view
    self.pickerView = [[HUIPickerView alloc] initWithFrame:CGRectMake(0, 10, 768, 140) row:10];
    [self.pickerView.leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerView.rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pickerView];
    
    // Set hiddenBtn hidden and background image
    self.hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hiddenBtn.frame = CGRectMake(0, 1, 768, 32);
    self.hiddenBtn.hidden = YES;
    self.hiddenBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_pull_ipad.png"]];
    [self.hiddenBtn addTarget:self action:@selector(hiddenPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.hiddenBtn];
    
    // Set hiddenBtn action of drag
    UISwipeGestureRecognizer *dragDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenDrag:)];
    dragDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.hiddenBtn addGestureRecognizer:dragDown];
    
    
    // Draw init players,num of 6
    numPlayers = 1;
    for (int i = 1; i <= 5; i++) {
        UIView *player = [[UIView alloc] initWithFrame:CGRectMake(28 + (28+120)*(i-1), 20, 120, 172)];
        [self drawPlayer:player index:i];
        if (i == 2) {
            self.selectBg = [[UIImageView alloc] initWithFrame:CGRectMake(166, 10, 139, 190)];
            [self.selectBg setImage:[UIImage imageNamed:@"photo_select_ipad.png"]];
            [self.scrollView addSubview:selectBg];
        }
    }
    UIView *player6 = [[UIView alloc] initWithFrame:CGRectMake(28, 210, 120, 172)];
    [self drawPlayer:player6 index:6];
    
    // Draw left button of nav
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 5, 35, 35);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_question_ipad.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(questionBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *questionBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [leftBtn release];
    self.navigationItem.leftBarButtonItem = questionBtn;
    
    // Draw right button of nav
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(723, 5, 35, 35);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_help_ipad.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(helpBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *helpBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn release];
    self.navigationItem.rightBarButtonItem = helpBtn;
    
    // Set Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPlayOrShakeBtn:) name:@"showPlayOrShakeBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakeDevice:) name:@"shakeDevice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertView:) name:@"showAlertView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMultiPlayer:) name:@"addMultiPlayer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeMultiPlayer:) name:@"removeMultiPlayer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNulBtn:) name:@"hideNulBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayNulBtn:) name:@"displayNulBtn" object:nil];
    
    //Set accelerometer
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = 0.1;
    self.accelerometer.delegate = self;
    
    // Draw playBtn and nextBtn
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.frame = CGRectMake(157, 795, 468, 123);
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_next_ipad.png"] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    self.nextBtn.hidden = YES;
    self.nextBtn.enabled = NO;
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(157, 795, 468, 123);
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"btn_shakeortap_ipad.png"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(shakeOrPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playBtn];
    
    self.nullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nullBtn.frame = CGRectMake(157, 795, 468, 123);
    [self.nullBtn addTarget:self action:@selector(pressButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nullBtn];
    
    
    // Set music play
    NSString *path = [[NSBundle mainBundle] pathForResource:@"chooseplayer" ofType:@"mp3"];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSURL *musicURL = [NSURL fileURLWithPath:path];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
        [audioPlayer setVolume:1.0];
        [audioPlayer setNumberOfLoops:0];
        [audioPlayer prepareToPlay];
    }
    
    // Set popoverController
    self.contentSizeForViewInPopover = CGSizeMake(320, 480);
}

- (void)viewDidUnload
{
    [self setPickerView:nil];
    [self setScrollView:nil];
    [self setNullBtn:nil];
    [self setPlayBtn:nil];
    [self setNextBtn:nil];
    [self setHiddenBtn:nil];
    [self setSelectBg:nil];
    [self setAudioPlayer:nil];
    [self setSenderBtn:nil];
    [self setDefaultName:nil];
    [self setPopoverController:nil];
    [self setTimer:nil];
    [self setAccelerometer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.nullBtn.hidden = YES;
    [super viewWillAppear:YES];
    self.isCanShake = YES;
    self.nextBtn.hidden    = YES;
    self.nextBtn.enabled   = NO;
    self.playBtn.hidden    = NO;
    self.playBtn.enabled   = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self invalidateTimer];
    self.isCanShake = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationPortrait == interfaceOrientation)||(UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation);
}

- (void)dealloc {
    [pickerView release];
    [scrollView release];
    [nullBtn release];
    [playBtn release];
    [nextBtn release];
    [hiddenBtn release];
    [selectBg release];
    [audioPlayer release];
    [senderBtn release];
    [defaultName release];
    [popoverController release];
    [timer release];
    [accelerometer release];
    [super dealloc];
}

#pragma mark - UIActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 &&[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //Take photo by camera
        [self getPicture:UIImagePickerControllerSourceTypeCamera];
    }else if ((buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])||(buttonIndex == 0 && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])) {
        //Chose photo from PhotoLibary
        [self getPicture:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

#pragma mark - UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    if (image != nil) {
        [self.senderBtn setImage:image forState:UIControlStateNormal];
    }
    [picker dismissModalViewControllerAnimated:YES];
    //iPad take or get picture,touch "use" to dismiss popover.
    [popoverController dismissPopoverAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIAccelerometer delegate methods

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    if (fabsf(acceleration.x > 1.5) || fabsf(acceleration.y > 1.5) || fabsf(acceleration.z > 1.5)) {
        //1.5 shake lightly, 2.0 
        if (self.isCanShake) {
            self.isCanShake = NO;
            self.playBtn.enabled = NO;
            self.nextBtn.enabled = NO;
            if ([self.hiddenBtn isHidden]) {
                [NSThread detachNewThreadSelector:@selector(showAllPlayers) toTarget:self withObject:nil];
                [NSThread sleepForTimeInterval:0.3];
            }else {
                //If keyboard is available,resign it.
                [self.view endEditing:YES];
            }
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(nextBtnPressed:) userInfo:nil repeats:NO];
            self.playerId = [self selectPlayer];
            
            self.nextBtn.hidden  = NO;
            self.nextBtn.enabled = YES;
            self.playBtn.hidden  = YES;
            self.playBtn.enabled = NO;
        }
    }
}

@end
