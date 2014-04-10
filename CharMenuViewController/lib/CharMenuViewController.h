//
//  CharMenuViewController.h
//  CharMenuViewController
//
//  Created by Andrew Charkin on 4/9/14.
//  Copyright (c) 2014 Charimon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CharMenuState) {
    CharMenuStateClosed,
    CharMenuStateOpened,
};

@interface CharMenuViewController : UIViewController
@property (strong, nonatomic) UIViewController *menuViewController;
@property (strong, nonatomic) UIViewController *contentViewController;
@property (nonatomic) CGFloat contentPeekSize;
@property (nonatomic, readonly) CharMenuState state;

-(void) toggleMenu;
-(void) setContentPeekSize:(CGFloat)contentPeekSize animated:(BOOL) animated;

//protected

@end
