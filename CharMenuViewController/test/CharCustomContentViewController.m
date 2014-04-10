//
//  CharCustomContentViewController.m
//  CharMenuViewController
//
//  Created by Andrew Charkin on 4/9/14.
//  Copyright (c) 2014 Charimon. All rights reserved.
//

#import "CharCustomContentViewController.h"
#import "CharMenuViewController.h"

@interface CharCustomContentViewController ()
@property (strong, nonatomic) UIButton *menuButton;
@end

@implementation CharCustomContentViewController

CGFloat const peekSize = 50.f;
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:self.menuButton
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.f
                                                              constant:20.f],
                                [NSLayoutConstraint constraintWithItem:self.menuButton
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.f
                                                              constant:0.f],
                                [NSLayoutConstraint constraintWithItem:self.menuButton
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:0.f
                                                              constant:peekSize],
                                [NSLayoutConstraint constraintWithItem:self.menuButton
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.menuButton
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1.f
                                                              constant:0.f],
                                ]];
}

-(UIButton *) menuButton {
    if(_menuButton) return _menuButton;
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuButton.backgroundColor = [UIColor orangeColor];
    [_menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _menuButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_menuButton];
    return _menuButton;
}

-(void) menuButtonClicked: (id) sender {
    if([self.parentViewController isKindOfClass:[CharMenuViewController class]]) {
        [((CharMenuViewController *)self.parentViewController) toggleMenu];
    }
}
@end
