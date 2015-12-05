//
//  ARRFailViewController.m
//  PhoneSpin
//
//  Created by Igor Arsenkin on 03.12.15.
//  Copyright © 2015 Igor Arsenkin. All rights reserved.
//

#import "ARRFailViewController.h"

#import "ARRFailView.h"
#import "ARRStartViewController.h"

#import "ARRUniversalMacros.h"

ARRViewControllerMainViewProperty(ARRFailViewController, mainView, ARRFailView)

@implementation ARRFailViewController

#pragma mark -
#pragma mark ARRFailViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Actions

- (IBAction)onTryAgainButton:(id)sender {
    [self presentViewController:[ARRStartViewController new] animated:YES completion:nil];
}

#pragma mark -
#pragma mark Event Handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
