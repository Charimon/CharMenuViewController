//
//  CharViewController.m
//  CharMenuViewController
//
//  Created by Andrew Charkin on 4/9/14.
//  Copyright (c) 2014 Charimon. All rights reserved.
//

#import "CharViewController.h"
#import "CharMenuViewController.h"
#import "CharCustomContentViewController.h"
#import "CharCustomMenuViewController.h"

@interface CharViewController ()
@property (strong, nonatomic) CharCustomMenuViewController *menuViewController;
@property (strong, nonatomic) CharCustomContentViewController *contentViewController;
@end

@implementation CharViewController

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CharMenuViewController *menuVC = [[CharMenuViewController alloc] init];
    menuVC.menuViewController = self.menuViewController;
    menuVC.contentViewController = self.contentViewController;
    [self.view addSubview:menuVC.view];
    [self addChildViewController:menuVC];
}

-(CharCustomMenuViewController *) menuViewController {
    if(_menuViewController) return _menuViewController;
    _menuViewController = [[CharCustomMenuViewController alloc] init];
    return _menuViewController;
}

-(CharCustomContentViewController *) contentViewController {
    if(_contentViewController) return _contentViewController;
    _contentViewController = [[CharCustomContentViewController alloc] init];
    return _contentViewController;
}

@end
