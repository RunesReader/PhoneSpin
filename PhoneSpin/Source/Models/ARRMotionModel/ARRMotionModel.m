//
//  ARRMotionModel.m
//  PhoneSpin
//
//  Created by Igor Arsenkin on 11.12.15.
//  Copyright © 2015 Igor Arsenkin. All rights reserved.
//

#import "ARRMotionModel.h"

#import "ARRUniversalMacros.h"

static const NSTimeInterval kARRUpdateInterval = 0.05f;
static const double         kARRAccuracyFactor = 0.13f;

@interface ARRMotionModel ()
@property (nonatomic, strong) CMMotionManager           *motionManager;
@property (nonatomic, assign) __block NSUInteger        circlesCount;

@end

@implementation ARRMotionModel

#pragma mark -
#pragma mark Class Methods

+ (instancetype)sharedMotionModel {
    static id __model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __model = [self new];
    });
    
    return __model;
}

#pragma mark -
#pragma mark Deallocation and Initializations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = kARRUpdateInterval;
        [self.motionManager startDeviceMotionUpdates];
    }
    
    return self;
}

#pragma mark -
#pragma mark Public

- (void)startMotionDetect {
    if (self.motionManager.deviceMotionAvailable) {
        CMAttitude *initialAttitude = self.motionManager.deviceMotion.attitude;
        self.circlesCount = 0;
        
        ARRWeakify(self);
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
                                                                toQueue:[NSOperationQueue mainQueue]
                                                            withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error)
         {
             if (error) {
                 NSLog(@"%@", error);
                 
                 return;
             }
             
             ARRStrongifyAndReturnIfNil(self);
             [motion.attitude multiplyByInverseOfAttitude:initialAttitude];
             double magnitude = [self magnitudeFromAttitude:motion.attitude];
             
             if (magnitude < kARRAccuracyFactor) {
                 self.circlesCount++;
             }
             
         }];
    }
    
}

- (void)stopMotionDetect {
    [self.motionManager stopDeviceMotionUpdates];
}

#pragma mark -
#pragma mark Private

// Calculate magnitude of vector (Pythagor theorem)
- (double)magnitudeFromAttitude:(CMAttitude *)attitude {
    return sqrt(pow(attitude.roll, 2.0f) + pow(attitude.yaw, 2.0f) + pow(attitude.pitch, 2.0f));
}

@end
