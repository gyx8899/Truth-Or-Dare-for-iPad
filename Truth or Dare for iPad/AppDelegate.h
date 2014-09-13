//
//  AppDelegate.h
//  Truth or Dare for iPad
//
//  Created by 015 YQ on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (retain, nonatomic) UINavigationController *navController;

- (void) createEditableCopyOfDatabaseIfNeeded;

@end
