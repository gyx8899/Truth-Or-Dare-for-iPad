//
//  ViewController.h
//  Troth or Dare for iPad
//
//  Created by 015 YQ on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUIPickerView.h"
#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAccelerometerDelegate>

@property (retain, nonatomic) HUIPickerView *pickerView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *nullBtn;
@property (retain, nonatomic) IBOutlet UIButton *playBtn;
@property (retain, nonatomic) IBOutlet UIButton *nextBtn;
@property (retain, nonatomic) IBOutlet UIButton *hiddenBtn;
@property (retain, nonatomic) UIImageView *selectBg;
@property (retain, nonatomic) AVAudioPlayer *audioPlayer;
@property (retain, nonatomic) UIButton *senderBtn;
@property (retain, nonatomic) NSString *defaultName;
@property (retain, nonatomic) UIPopoverController *popoverController;
@property (retain, nonatomic) NSTimer *timer;
@property (retain, nonatomic) UIAccelerometer *accelerometer;
@property int numPlayers;
@property int playerId;
@property BOOL isCanShake;

- (IBAction)hiddenPressed:(id)sender;
- (IBAction)shakeOrPlay:(id)sender;
- (IBAction)nextBtnPressed:(id)sender;
- (IBAction)leftBtnPressed:(id)sender;
- (IBAction)rightBtnPressed:(id)sender;
- (IBAction)textFieldBegin:(id)sender;
- (IBAction)textFieldEnd:(id)sender;
- (IBAction)hiddenPressed:(id)sender;
- (IBAction)hiddenDrag:(id)sender;
- (IBAction)helpBtnPressed:(id)sender;
- (IBAction)questionBtnPressed:(id)sender;
- (IBAction)playerPressed:(id)sender;

- (int)selectPlayer;

- (void)showAllPlayers;
- (void)adjustScrollViewHeight;
- (void)drawPlayer:(UIView *)player index:(int )index;
- (void)playMusic;
- (void)playAnimation:(UIView *)player;
- (void)showAlert:(NSString *)msg;
- (void)showAlertView:(NSNotification *)notification;
- (void)getPicture:(UIImagePickerControllerSourceType)type;
- (void)showPlayOrShakeBtn:(NSNotification *)notification;
- (void)shakeDevice:(NSNotification *)notification;
- (void)addPlayer;
- (void)addMultiPlayer:(NSNotification *)notification;
- (void)removePlayer;
- (void)removeMultiPlayer:(NSNotification *)notification;

@end
