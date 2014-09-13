//
//  PlayerViewController.m
//  Troth or Dare for iPad
//
//  Created by 015 YQ on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

@synthesize truthButton;
@synthesize dareButton;
@synthesize randomButton;
@synthesize textView;
@synthesize myTextView;
@synthesize hintImage;
@synthesize accelerometer;
@synthesize icon;
@synthesize playerName;
@synthesize truthOrDareQuestion;
@synthesize isCanShake;

#pragma mark - View lifecycle

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
    
    // Set background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg_ipad.png"]];
    
    // Set nav title
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 32)];
    titleLabel.font = [UIFont boldSystemFontOfSize:30];
    titleLabel.textColor = [UIColor yellowColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = self.playerName;
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
    // Set nav left (back) button
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 5, 35, 35);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_back_ipad.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backBtn;
    [backBtn release];
    
    // Set nav right (player Image) view
    UIImageView *photoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_frame_ipad.png"]];
    photoImage.frame = CGRectMake(0, 0, 36, 36);
    
    UIView *playerImage = [[UIView alloc] initWithFrame:CGRectMake(10, 8, 36, 36)];
    [playerImage addSubview:photoImage];
    [photoImage release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.icon];
    imageView.frame = CGRectMake(2, 2, 32, 32);
    [playerImage addSubview:imageView];
    [imageView release];
    
    UIBarButtonItem *imageButton = [[UIBarButtonItem alloc] initWithCustomView:playerImage];
    [playerImage release];
    
    self.navigationItem.rightBarButtonItem = imageButton;
    [imageButton release];
    
    // Set textView 
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(1046, 300, 677, 384)]; 
    self.textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textview_bg_ipad.png"]];
    self.textView.editable = NO;
    [self.view addSubview:self.textView];
    
    self.myTextView = [[UITextView alloc] initWithFrame:CGRectMake(1076, 300, 617, 384)];
    self.myTextView.backgroundColor = [UIColor clearColor];
    self.myTextView.textColor = [UIColor colorWithRed:65/255.0 green:51/255.0 blue:14/255.0 alpha:1.0];
    self.myTextView.font = [UIFont systemFontOfSize:38];
    self.myTextView.opaque = NO;
    self.myTextView.editable = NO;
    [self.view addSubview:self.myTextView];
    
    // Set accelerometer
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = 0.1;
    self.accelerometer.delegate = self;
    
    // Set isCanShake
    self.isCanShake = false;
}

- (void)viewDidUnload
{
    [self setTruthButton:nil];
    [self setDareButton:nil];
    [self setRandomButton:nil];
    [self setHintImage:nil];
    [self setAccelerometer:nil];
    [self setIcon:nil];
    [self setPlayerName:nil];
    [self setTruthOrDareQuestion:nil];
    [self setTextView:nil];
    [self setMyTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationPortrait == interfaceOrientation)||(UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation);
}

- (void)dealloc {
    [truthButton release];
    [dareButton release];
    [randomButton release];
    [hintImage release];
    [accelerometer release];
    [icon release];
    [playerName release];
    [truthOrDareQuestion release];
    [textView release];
    [myTextView release];
    [super dealloc];
}

#pragma mark - btn methods

- (IBAction)truthPressed:(id)sender {
    [UIView animateWithDuration:0.6 animations:^(void){
        [self.dareButton setCenter:CGPointMake(self.dareButton.center.x, self.dareButton.center.y + 1000)];
        [self.randomButton setCenter:CGPointMake(self.randomButton.center.x, self.randomButton.center.y + 1000)];
        [self.hintImage setCenter:CGPointMake(self.hintImage.center.x, self.hintImage.center.y - 300)];
        [self.myTextView setCenter:CGPointMake(self.myTextView.center.x - 1000, self.myTextView.center.y)];
        [self.textView setCenter:CGPointMake(self.textView.center.x - 1000, self.textView.center.y)];
    }];
    self.truthOrDareQuestion = [self getQuestionByType:truthType];
    self.myTextView.text = self.truthOrDareQuestion.content;
    [self.truthButton removeTarget:self action:@selector(truthPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)darePressed:(id)sender {
    [UIView animateWithDuration:0.6 animations:^(void){
        [self.dareButton setCenter:CGPointMake(self.truthButton.center.x, self.truthButton.center.y)];
        [self.randomButton setCenter:CGPointMake(self.randomButton.center.x, self.randomButton.center.y + 1000)];
        [self.hintImage setCenter:CGPointMake(self.hintImage.center.x, self.hintImage.center.y -300)];
        [self.myTextView setCenter:CGPointMake(self.myTextView.center.x - 1000,self.myTextView.center.y)];
        [self.textView setCenter:CGPointMake(self.textView.center.x - 1000, self.textView.center.y)];
        [self.truthButton setCenter:CGPointMake(self.truthButton.center.x, self.truthButton.center.y - 1000)];
    }];
    self.truthOrDareQuestion = [self getQuestionByType:dareType];
    self.myTextView.text = self.truthOrDareQuestion.content;
    
    [self.dareButton removeTarget:self action:@selector(darePressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)randomPressed:(id)sender {
    self.truthOrDareQuestion = [self getQuestionByType:randomType];
    [UIView animateWithDuration:0.6 animations:^(void){
        [self.randomButton setCenter:CGPointMake(self.randomButton.center.x, self.randomButton.center.y + 1000)];
        [self.hintImage setCenter:CGPointMake(self.hintImage.center.x, self.hintImage.center.y - 300)];
        [self.myTextView setCenter:CGPointMake(self.myTextView.center.x - 1000, self.myTextView.center.y)];
        [self.textView setCenter:CGPointMake(self.textView.center.x - 1000, self.textView.center.y)];
        if ([self.truthOrDareQuestion.truthOrDare isEqualToString:@"dare"]) {
            [self.dareButton setCenter:CGPointMake(self.truthButton.center.x, self.truthButton.center.y)];
            [self.truthButton setCenter:CGPointMake(self.truthButton.center.x,self.truthButton.center.y - 1000)];
            [self.dareButton removeTarget:self action:@selector(darePressed:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [self.dareButton setCenter:CGPointMake(self.dareButton.center.x, self.dareButton.center.y +1000)];
            [self.truthButton removeTarget:self action:@selector(truthPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.myTextView.text = self.truthOrDareQuestion.content;
    }];
}

- (IBAction)backBtnPressed:(id)sender
{
    isCanShake = true;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPlayOrShakeBtn" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Truth of Dare Question

//Get a question with a type
//type includes truth,dare and random.
- (Question *)getQuestionByType:(int)type{
    SQLite3Util *sqlUtil = [[SQLite3Util alloc] init];
    Question *question;
    NSMutableArray *array;
    int count;
    switch (type) {
        case truthType:
            array = [sqlUtil getTruthOrDares:YES];
            int truthId = arc4random()%[array count];
            question = [array objectAtIndex:truthId];
            break;
        case dareType:
            array = [sqlUtil getTruthOrDares:NO];
            int dareId = arc4random()%[array count];
            question = [array objectAtIndex:dareId];
            break;  
        case randomType:
            count = [sqlUtil getCountOfDB];
            int randomId = arc4random()%count;
            question = [sqlUtil getQuestion:randomId];
            [sqlUtil closeDatabase];
            break;
        default:
            break;
    }
    [sqlUtil release];
    isCanShake = true;
    return question;
}

#pragma mark - Accelerometer delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    if (fabs(acceleration.x > 1.5) || fabs(acceleration.y > 1.5) || fabs(acceleration.z > 1.5)) {
        //1.5 shake lightly, 2.0 
        if (isCanShake) {
            isCanShake = false;
            [NSThread detachNewThreadSelector:@selector(backBtnPressed:) toTarget:self withObject:nil];
            [NSThread sleepForTimeInterval:0.8];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shakeDevice" object:nil];
        }
    }
}

@end
