//
//  ARRStartViewController.m
//  PhoneSpin
//
//  Created by Igor Arsenkin on 25.11.15.
//  Copyright © 2015 Igor Arsenkin. All rights reserved.
//

#import "ARRStartViewController.h"

#import "ARRStartView.h"

#import "ARRUniversalMacros.h"

static const NSTimeInterval kARRTimerInterval   = 1.0;
static const NSInteger      kARRStartDelay      = 3;

ARRViewControllerMainViewProperty(ARRStartViewController, mainView, ARRStartView)

@interface ARRStartViewController ()
@property (nonatomic, assign) NSInteger counter;

@end

@implementation ARRStartViewController

#pragma mark -
#pragma mark ARRStartViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Countdown Timer

- (void)startConutdownWithValue:(NSInteger)startValue {
    self.counter = startValue;
    [self.mainView fillWithCountdownValue:startValue];
    
    __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kARRTimerInterval
                                                               target:self
                                                             selector:@selector(advanceTimer:)
                                                             userInfo:nil
                                                              repeats:YES];
}

- (void)advanceTimer:(NSTimer *)timer {
    self.counter--;
    NSInteger counter = self.counter;
    
    if (counter < 0) {
        [timer invalidate];
        
        return;
    }
    
    [self.mainView fillWithCountdownValue:counter];
}

#pragma mark -
#pragma mark Event Handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startConutdownWithValue:kARRStartDelay];
    self.mainView.subviewsVisible = NO;
}

@end
