//
//  CharMenuViewController.m
//  CharMenuViewController
//
//  Created by Andrew Charkin on 4/9/14.
//  Copyright (c) 2014 Charimon. All rights reserved.
//

#import "CharMenuViewController.h"

@interface CharMenuViewController () <UIGestureRecognizerDelegate>
@property (atomic) BOOL animating;
@property (nonatomic) BOOL panning;
@property (strong, nonatomic) NSLayoutConstraint *contentViewLeadingConstraint;
@property (nonatomic, readwrite) CharMenuState state;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *peekTapRecognizer;

@end

@implementation CharMenuViewController
CGFloat const CHAR_MENU_SNAP_RATIO = .3333333f;

-(instancetype) init {
    self = [super init];
    if(self) {
        self.contentPeekSize = 50.f;
        self.state = CharMenuStateClosed;
    }
    return self;
}

-(void) setContentPeekSize:(CGFloat)contentPeekSize animated:(BOOL) animated{
    if(animated && _contentPeekSize != contentPeekSize && self.state == CharMenuStateOpened) [self openMenu];
    _contentPeekSize = contentPeekSize;
}

-(void) setMenuViewController:(UIViewController *)menuViewController {
    [_menuViewController removeFromParentViewController];
    [_menuViewController.view removeFromSuperview];
    _menuViewController = menuViewController;
    
    [self addChildViewController:_menuViewController];
    [self.view addSubview:_menuViewController.view];
    [self.view sendSubviewToBack:_menuViewController.view];
    
    _menuViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:_menuViewController.view
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.f
                                                              constant:0.f],
                                [NSLayoutConstraint constraintWithItem:_menuViewController.view
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.f
                                                              constant:0.f],
                                [NSLayoutConstraint constraintWithItem:_menuViewController.view
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1.f
                                                              constant:-self.contentPeekSize],
                                [NSLayoutConstraint constraintWithItem:_menuViewController.view
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1.f
                                                              constant:0.f],
                                ]];
}

-(void) setContentViewController:(UIViewController *)contentViewController {
    [_contentViewController removeFromParentViewController];
    [_contentViewController.view removeFromSuperview];
    _contentViewController = contentViewController;
    
    [self addChildViewController:_contentViewController];
    [self.view addSubview:_contentViewController.view];
    [self.view bringSubviewToFront:_contentViewController.view];
    
    _contentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:_contentViewController.view
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.f
                                                              constant:0.f],
                                [NSLayoutConstraint constraintWithItem:_contentViewController.view
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1.f
                                                              constant:0.f],
                                [NSLayoutConstraint constraintWithItem:_contentViewController.view
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1.f
                                                              constant:0.f],
                                ]];
    
    self.contentViewLeadingConstraint = [NSLayoutConstraint constraintWithItem:_contentViewController.view
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.f
                                                                      constant:0.f];
    [self.view addConstraint:self.contentViewLeadingConstraint];
    
    
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:self.shadowView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentViewController.view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.f
                                                              constant:0.f],
                                [NSLayoutConstraint constraintWithItem:self.shadowView
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentViewController.view
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.f
                                                              constant:0.f],
                                [NSLayoutConstraint constraintWithItem:self.shadowView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:0.f
                                                              constant:8.f],
                                [NSLayoutConstraint constraintWithItem:self.shadowView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentViewController.view
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1.f
                                                              constant:0.f],
                                ]];
    [self.view bringSubviewToFront:self.shadowView];
}
-(void) loadView {
    [super loadView];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    [self.view addGestureRecognizer:self.peekTapRecognizer];
}
-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if(self.animating || self.panning) return;
    
    if(self.state == CharMenuStateOpened) {
        self.contentViewLeadingConstraint.constant = self.view.bounds.size.width - self.contentPeekSize;
    }
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.shadow.frame = CGRectMake(0, 0, self.shadowView.bounds.size.width, self.shadowView.bounds.size.height);
}

-(UIView *) shadowView {
    if(_shadowView) return _shadowView;
    _shadowView = [[UIView alloc] init];
    
    
    self.shadow = [CAGradientLayer layer];
    self.shadow.startPoint = CGPointMake(0, 0.5);
    self.shadow.endPoint = CGPointMake(1.0, 0.5);
    self.shadow.colors = @[ (id)[UIColor colorWithWhite:49.f/255.f alpha:0].CGColor, (id)[UIColor colorWithWhite:49.f/255.f alpha:.22f].CGColor, (id)[UIColor colorWithWhite:49.f/255.f alpha:.6f].CGColor ];
    self.shadow.locations = @[ [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:.8f], [NSNumber numberWithFloat:1.f] ];
    [_shadowView.layer addSublayer:self.shadow];
    
    [self.view addSubview:_shadowView];
    _shadowView.translatesAutoresizingMaskIntoConstraints = NO;
    return _shadowView;
}

-(UIPanGestureRecognizer *) panGestureRecognizer {
    if(_panGestureRecognizer) return _panGestureRecognizer;
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panning:)];
    _panGestureRecognizer.delegate = self;
    return _panGestureRecognizer;
}
-(void) panning: (UIPanGestureRecognizer *) panGestureRecognizer {
    if(panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.panning = YES;
    } else if(panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
        if(self.state == CharMenuStateOpened) {
            self.contentViewLeadingConstraint.constant = self.view.bounds.size.width - self.contentPeekSize + translation.x;
            if(self.contentViewLeadingConstraint.constant > self.view.bounds.size.width - self.contentPeekSize) {
                self.contentViewLeadingConstraint.constant = self.view.bounds.size.width - self.contentPeekSize;
                [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
            }
        }
    } else if(panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled || panGestureRecognizer.state == UIGestureRecognizerStateFailed) {
        self.panning = NO;
        
        CGFloat maxDistance = self.view.bounds.size.width - self.contentPeekSize;
        CGFloat xVelocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view].x;
        CGFloat distanceFromLeft = self.contentViewLeadingConstraint.constant;
        CGFloat distanceFromRight = maxDistance - distanceFromLeft;
        
        if(self.state == CharMenuStateOpened) {
            if(xVelocity < -1000) [self closeMenu];
            else if(xVelocity > 1000) [self openMenu];
            else if( distanceFromRight < maxDistance*CHAR_MENU_SNAP_RATIO) [self openMenu];
            else [self closeMenu];
        }
    }
}

-(UITapGestureRecognizer *) peekTapRecognizer {
    if(_peekTapRecognizer) return _peekTapRecognizer;
    _peekTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(peekTapped:)];
    _peekTapRecognizer.delegate = self;
    return _peekTapRecognizer;
}
-(void) peekTapped: (UITapGestureRecognizer *) peekTapRecognizer {
    [self closeMenu];
}

-(void) toggleMenu {
    if(self.state == CharMenuStateOpened) {
        [self closeMenu];
    } else if(self.state == CharMenuStateClosed) {
        [self openMenu];
    }
}

-(void) openMenu {
    if(self.animating) return;
    self.animating = YES;
    self.contentViewController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:.6f
                          delay:0.f
         usingSpringWithDamping:.9f
          initialSpringVelocity:1.1f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.contentViewLeadingConstraint.constant = self.view.bounds.size.width - self.contentPeekSize;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         
                         self.state = CharMenuStateOpened;
                         self.animating = NO;
                     }];
}

-(void) closeMenu {
    if(self.animating) return;
    self.animating = YES;
    [UIView animateWithDuration:.5f
                          delay:0.f
         usingSpringWithDamping:.95f
          initialSpringVelocity:1.1f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.contentViewLeadingConstraint.constant = 0.f;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         
                         self.state = CharMenuStateClosed;
                         self.contentViewController.view.userInteractionEnabled = YES;
                         self.animating = NO;
                     }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(self.state == CharMenuStateOpened && gestureRecognizer == self.panGestureRecognizer) {
        return YES;
    } else if(self.state == CharMenuStateOpened && gestureRecognizer == self.peekTapRecognizer) {
        return CGRectContainsPoint(self.contentViewController.view.bounds, [touch locationInView:self.contentViewController.view]);
    } else return NO;
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
