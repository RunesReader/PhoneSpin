//
//  ARRStartViewController.m
//  PhoneSpin
//
//  Created by Igor Arsenkin on 25.11.15.
//  Copyright © 2015 Igor Arsenkin. All rights reserved.
//

#import "ARRStartViewController.h"

#import "ARRStartView.h"
#import "ARRFailViewController.h"
#import "ARRResultViewController.h"
#import "ARRMotionModel.h"
#import "ARRScoreModel.h"
#import <AudioToolbox/AudioToolbox.h>

#import "ARRUniversalMacros.h"

typedef NS_ENUM(NSInteger, ARRControllerState) {
    kARRStartScreen,
    kARRFirstCountdown,
    kARRSecondCountdown,
    kARRTimeIsUp
};

static const NSTimeInterval kARRTimerInterval   = 1.0;
static const NSInteger      kARRStartDelay      = 3;
static const NSInteger      kARRSpiningTime     = 8;

ARRViewControllerMainViewProperty(ARRStartViewController, mainView, ARRStartView)

@interface ARRStartViewController ()
@property (nonatomic, assign)   NSInteger           counter;
@property (nonatomic, assign)   ARRControllerState  state;
@property (nonatomic, strong)   NSTimer             *timer;

@end

@implementation ARRStartViewController

#pragma mark -
#pragma mark ARRStartViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.state = kARRStartScreen;
    self.motionModel = [ARRMotionModel sharedMotionModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Countdown Timer

- (void)startConutdownWithValue:(NSInteger)startValue {
    self.counter = startValue;
    [self.mainView fillWithCountdownValue:startValue];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kARRTimerInterval
                                                               target:self
                                                             selector:@selector(advanceTimer:)
                                                             userInfo:nil
                                                              repeats:YES];
}

- (void)advanceTimer:(NSTimer *)timer {
    self.counter--;
    
    if (self.counter < 0) {
        if (kARRFirstCountdown == self.state) {
            [self setupSpinning];
        } else {
            [timer invalidate];
            [self stopSpinning];
            
            ARRWeakify(self);
            [self presentViewController:[ARRResultViewController new] animated:NO completion:^{
                ARRStrongifyAndReturnIfNil(self);
                self.mainView.subviewsVisible = YES;
                [self.mainView fillWithScoreModel:self.mainView.scoreModel];
            }];
            
            return;
        }
    }
    
    [self.mainView fillWithCountdownValue:self.counter];
}

#pragma mark -
#pragma mark Event Handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = kARRFirstCountdown;
    [self startConutdownWithValue:kARRStartDelay];
    self.mainView.subviewsVisible = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.timer invalidate];
    
    ARRWeakify(self);
    [self presentViewController:[ARRFailViewController new] animated:NO completion:^{
        ARRStrongifyAndReturnIfNil(self);
        self.mainView.subviewsVisible = YES;
    }];
}

#pragma mark -
#pragma mark Private

- (void)playSound {
    static SystemSoundID sound;
    
    if (!sound) {
        NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:@"beep-09" ofType:@"wav"];
        NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &sound);
    }
    
    AudioServicesPlaySystemSound(sound);
}

- (void)setupSpinning {
    self.counter = kARRSpiningTime;
    self.state = kARRSecondCountdown;
    [self.motionModel startMotionDetect];
    [self playSound];
}

- (void)stopSpinning {
    self.state = kARRTimeIsUp;
    [self.motionModel stopMotionDetect];
    [[ARRScoreModel sharedScoreModel] setCurrentScore:self.motionModel.circlesCount];
    [self playSound];
}

@end
