//
//  CharMenuViewControllerDelegate.h
//  CharMenuViewController
//
//  Created by Andrew Charkin on 4/15/14.
//  Copyright (c) 2014 Charimon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CharMenuViewControllerDelegate <NSObject>
@optional
-(void) willOpenMenu;
-(void) didOpenMenu;

-(void) willCloseMenu;
-(void) didCloseMenu;
@end
