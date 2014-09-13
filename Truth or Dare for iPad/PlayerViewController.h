//
//  PlayerViewController.h
//  Troth or Dare for iPad
//
//  Created by 015 YQ on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Question.h"
#import "SQLite3Util.h"

#define truthType  0
#define dareType   1
#define randomType 2

@interface PlayerViewController : UIViewController<UIAccelerometerDelegate>

@property (retain, nonatomic) IBOutlet UIButton *truthButton;
@property (retain, nonatomic) IBOutlet UIButton *dareButton;
@property (retain, nonatomic) IBOutlet UIButton *randomButton;
@property (retain, nonatomic) UITextView *textView;
@property (retain, nonatomic) IBOutlet UITextView *myTextView;
@property (retain, nonatomic) IBOutlet UIImageView *hintImage;
@property (retain, nonatomic) UIAccelerometer *accelerometer;
@property (retain, nonatomic) UIImage *icon;
@property (retain, nonatomic) NSString *playerName;
@property (retain, nonatomic) Question *truthOrDareQuestion;
@property BOOL isCanShake;

- (IBAction)truthPressed:(id)sender;
- (IBAction)darePressed:(id)sender;
- (IBAction)randomPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;

- (Question *)getQuestionByType:(int)type;

@end
