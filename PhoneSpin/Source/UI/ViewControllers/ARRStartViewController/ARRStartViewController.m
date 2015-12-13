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

static NSString * const     kARRStartFile       = @"robot-start";
static NSString * const     kARRStopFile        = @"robot-stop";
static NSString * const     kARRFartFile        = @"fart-01";
static NSString * const     kARRWav             = @"wav";

ARRViewControllerMainViewProperty(ARRStartViewController, mainView, ARRStartView)

@interface ARRStartViewController () {
    SystemSoundID   startSound;
    SystemSoundID   stopSound;
    SystemSoundID   fartSound;
}
@property (nonatomic, assign)   NSInteger           counter;
@property (nonatomic, assign)   ARRControllerState  state;
@property (nonatomic, strong)   NSTimer             *timer;

@end

@implementation ARRStartViewController

#pragma mark -
#pragma mark Deallocation and Initializations

- (void)dealloc {
    AudioServicesDisposeSystemSoundID(startSound);
    AudioServicesDisposeSystemSoundID(stopSound);
    AudioServicesDisposeSystemSoundID(fartSound);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.motionModel = [ARRMotionModel sharedMotionModel];
        
        [self createSound:&startSound withResource:kARRStartFile ofType:kARRWav];
        [self createSound:&stopSound withResource:kARRStopFile ofType:kARRWav];
        [self createSound:&fartSound withResource:kARRFartFile ofType:kARRWav];
    }
    
    return self;
}

#pragma mark -
#pragma mark ARRStartViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.state = kARRStartScreen;
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
            [self stopSpinning];
            
            ARRWeakify(self);
            [self presentViewController:[ARRResultViewController new] animated:NO completion:^{
                ARRStrongifyAndReturnIfNil(self);
                self.mainView.subviewsVisible = YES;
                self.state = kARRStartScreen;
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
    if (kARRStartScreen == self.state) {
        self.state = kARRFirstCountdown;
        [self startConutdownWithValue:kARRStartDelay];
        self.mainView.subviewsVisible = NO;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.timer invalidate];
    AudioServicesPlaySystemSound(fartSound);
    
    ARRWeakify(self);
    [self presentViewController:[ARRFailViewController new] animated:NO completion:^{
        ARRStrongifyAndReturnIfNil(self);
        self.mainView.subviewsVisible = YES;
        self.state = kARRStartScreen;
    }];
}

#pragma mark -
#pragma mark Private

- (void)setupSpinning {
    self.counter = kARRSpiningTime;
    self.state = kARRSecondCountdown;
    [self.motionModel startMotionDetect];
    AudioServicesPlaySystemSound(startSound);
}

- (void)stopSpinning {
    [self.timer invalidate];
    self.state = kARRTimeIsUp;
    [self.motionModel stopMotionDetect];
    [[ARRScoreModel sharedScoreModel] setCurrentScore:self.motionModel.circlesCount];
    AudioServicesPlaySystemSound(stopSound);
}

- (void)createSound:(SystemSoundID *)sound withResource:(NSString *)resource ofType:(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    NSURL *urlSound = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlSound, sound);
}

@end
