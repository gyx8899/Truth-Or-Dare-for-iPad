//
//  QuestionViewController.h
//  Troth or Dare for iPad
//
//  Created by 015 YQ on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "SQLite3Util.h"
#import "Question.h"
#import "BSSegmentedControl.h"

@interface QuestionViewController : UITableViewController<UIActionSheetDelegate>

@property (retain, nonatomic) BSSegmentedControl *truthOrDare;
@property (retain, nonatomic) IBOutlet UITableView *qusetionTableView;
@property (retain, nonatomic) NSMutableArray *truthArray;
@property (retain, nonatomic) NSMutableArray *dareArray;
@property (retain, nonatomic) NSMutableArray *listData;
@property (retain, nonatomic) UIActionSheet *actionSheet;
@property int questionType;
@property BOOL dismiss;

- (IBAction)homeBtnPressed:(id)sender;
- (IBAction)addBtnPressed:(id)sender;
- (IBAction)switchTruthOrDare:(UISegmentedControl *)segmentedControl;
- (void)refresh:(NSNotification *)notification;

@end
