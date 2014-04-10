//
//  CharCustomMenuViewController.m
//  CharMenuViewController
//
//  Created by Andrew Charkin on 4/9/14.
//  Copyright (c) 2014 Charimon. All rights reserved.
//

#import "CharCustomMenuViewController.h"

@interface CharCustomMenuViewController ()
@property (strong, nonatomic) UIView *header;
@end

@implementation CharCustomMenuViewController

-(UIView *) header {
    if(_header) return _header;
    _header = [[UIView alloc] init];
    _header.backgroundColor = [UIColor lightGrayColor];
    _header.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_header];
    return _header;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:self.header
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.f
                                                              constant:28.f],
                                [NSLayoutConstraint constraintWithItem:self.header
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.f
                                                              constant:8.f],
                                [NSLayoutConstraint constraintWithItem:self.header
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.f
                                                              constant:-8.f],
                                [NSLayoutConstraint constraintWithItem:self.header
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:0.f
                                                              constant:60.f],
                                
                                ]];
}

@end
