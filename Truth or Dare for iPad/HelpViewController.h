//
//  HelpViewController.h
//  Troth or Dare for iPad
//
//  Created by 015 YQ on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface HelpViewController : UIViewController<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>


- (IBAction)homeBtnPressed:(id)sender;
- (IBAction)contactBtnPressed:(id)sender;

@end
