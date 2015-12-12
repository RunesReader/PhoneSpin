//
//  ARRMotionModel.m
//  PhoneSpin
//
//  Created by Igor Arsenkin on 11.12.15.
//  Copyright © 2015 Igor Arsenkin. All rights reserved.
//

#import "ARRMotionModel.h"

@interface ARRMotionModel ()
@property (nonatomic, strong) CMMotionManager *motionManager;

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
    }
    
    return self;
}

#pragma mark -
#pragma mark Public

- (void)startMotionDetect {
    
}

- (void)stopMotionDetect {
    [self.motionManager stopDeviceMotionUpdates];
}

@end
