//
//  ViewController.m
//  _KKAnimationDemo
//
//  Created by 8kana on 16/3/29.
//  Copyright © 2016年 8kana. All rights reserved.
//

#import "ViewController.h"
#import "AnimationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AnimationView *view = [[AnimationView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    self.view.backgroundColor = [UIColor yellowColor];
}



@end
