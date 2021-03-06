//
//  HUIPickerView.m
//  Truth or Dare
//
//  Created by YQ-010 on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HUIPickerView.h"
#import <UIKit/UIKit.h>

@implementation HUIPickerView

@synthesize playerPicker;
@synthesize leftBtn;
@synthesize rightBtn;
@synthesize temp;
@synthesize isSendingNotifi;
- (id)initWithFrame:(CGRect)frame row:(int)rows{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        //Set Background
        UIImageView *imageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"players_bg_ipad.png"]];
        [self addSubview:imageView];
        [self sendSubviewToBack:imageView];
        [imageView release];
        
        //Set the selected player background
        UIView *selectBg = [[UIView alloc] initWithFrame:CGRectMake(347, 47, 75, 57)];//?
        [selectBg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"player_select_ipad.png"]]];
        [selectBg setOpaque:NO];
        [self insertSubview:selectBg atIndex:60];
        
        //Add left button
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 50, 51, 57);
        [leftBtn setImage:[UIImage imageNamed:@"btn_left_ipad.png"] forState:UIControlStateNormal];
        [self addSubview:leftBtn];
        
        //Add right button
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(720, 50, 51, 57);
        [rightBtn setImage:[UIImage imageNamed:@"btn_right_ipad.png"] forState:UIControlStateNormal];
        [self addSubview:rightBtn];
        
        //Add players picker
        self.playerPicker = [[UIScrollView alloc] initWithFrame:CGRectMake(51, 50, 666, 57)];
        [self.playerPicker setContentSize:CGSizeMake(4*74+49*74+4*74, 0)];
        for (int i = -1; i <= 51; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(74*(i + 1), -3, 70, 57)];
            [label setBackgroundColor:[UIColor clearColor]];
            label.textColor = [UIColor colorWithRed:7/255.0 green:53/255.0 blue:69/255.0 alpha:1.0];
            label.textAlignment = UITextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:28];
            if (i > 2) {
                label.text = [NSString stringWithFormat:@"%d", i - 1];
            }
            [self.playerPicker addSubview:label];
        }
        
        [self.playerPicker setShowsHorizontalScrollIndicator:NO];
        [self.playerPicker setDelegate:self];
        [self.playerPicker setContentOffset:CGPointMake(4*74, 0) animated:NO];
        [self addSubview:self.playerPicker];

    }
    self.isSendingNotifi = NO;
    return self;
}

- (int)getIndex{
    return (self.playerPicker.contentOffset.x + 37)/74+2;
}

- (void)sendNotification{
    self.temp = [self getIndex] - playerIndex; 
    if (self.temp > 0) {
        //Add players
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addMultiPlayer" object:nil];
    }
    else if (self.temp < 0) {
        //Remove players
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeMultiPlayer" object:nil];
    }
    else{
        if ([self getIndex] >= 50) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showAlertView" object:nil];
        }
        if ([self getIndex] <= 2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showAlertView" object:nil];
        }
    }
    //左右两侧连续滑动时，更新playerIndex.(默认只在单侧滑动scrollViewWillBeginDragging时，才更新playerIndex)
    playerIndex = [self getIndex];
}

#pragma mark ScrollView Degelate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //Selected index's color changed.
    static int newIndex = 6;
    static int oldIndex = 6;
    newIndex = (self.playerPicker.contentOffset.x + 37)/74 + 4;
    if (newIndex != oldIndex && newIndex > 3 && newIndex <53) {
        UILabel *labelOld = [self.playerPicker.subviews objectAtIndex:oldIndex];
        labelOld.textColor = [UIColor colorWithRed:7/255.0 green:53/255.0 blue:69/255.0 alpha:1.0];
        UILabel *labelNew = [self.playerPicker.subviews objectAtIndex:newIndex];
        labelNew.textColor = [UIColor colorWithRed:220/255.0 green:255/255.0 blue:142/255.0 alpha:1.0];
        oldIndex = newIndex;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayNulBtn" object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float offsetX = scrollView.contentOffset.x + 37;
    int index = offsetX/74;
    if ((int)scrollView.contentOffset.x%74 != 0) {
        [scrollView setContentOffset:CGPointMake(index*74, 0) animated:YES];
    }
    [self sendNotification];
    self.isSendingNotifi = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    float offsetX = scrollView.contentOffset.x + 37;
    int index = offsetX/74;
    if ((int)scrollView.contentOffset.x%74 != 0) {
        [scrollView setContentOffset:CGPointMake(index*74, 0) animated:YES];
    }
    if (!decelerate && self.isSendingNotifi == NO) {
        [self sendNotification];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!scrollView.decelerating) {
        playerIndex = [self getIndex];
        self.isSendingNotifi = NO;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNulBtn" object:nil];
}
@end
