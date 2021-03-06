//
//  ARRResultViewController.m
//  PhoneSpin
//
//  Created by Igor Arsenkin on 04.12.15.
//  Copyright © 2015 Igor Arsenkin. All rights reserved.
//

#import "ARRResultViewController.h"

#import "ARRResultView.h"
#import "ARRStartViewController.h"

#import "ARRUniversalMacros.h"

ARRViewControllerMainViewProperty(ARRResultViewController, mainView, ARRResultView)

@implementation ARRResultViewController

#pragma mark -
#pragma mark ARRResultViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Actions

- (IBAction)onTryAgainButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSeeChartButton:(UIButton *)sender {
    
}

#pragma mark -
#pragma mark Event Handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

@end
