//
//  AddOrEditQuesController.h
//  Troth or Dare for iPad
//
//  Created by 015 YQ on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLite3Util.h"

@interface AddOrEditQuesController : UIViewController

@property (retain, nonatomic) IBOutlet UINavigationBar *navgationBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *navgationItem;
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet UITextView *myTextView;
@property (retain, nonatomic) NSString *content;
@property int id;
@property int type;

-(IBAction)cancelBtnPressed:(id)sender;
-(IBAction)saveBtnPressed:(id)sender;

@end
