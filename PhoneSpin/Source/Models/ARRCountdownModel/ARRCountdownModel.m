//
//  ARRCountdownModel.m
//  PhoneSpin
//
//  Created by Igor Arsenkin on 03.12.15.
//  Copyright © 2015 Igor Arsenkin. All rights reserved.
//

#import "ARRCountdownModel.h"

static const NSTimeInterval kARRTimerInterval = 1.0;

@interface ARRCountdownModel ()
@property (nonatomic, assign) NSInteger counter;

@end

#pragma mark -
#pragma mark Public

@implementation ARRCountdownModel

- (void)startConutdownWithValue:(NSInteger)startValue {
    self.counter = startValue;
    
    __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kARRTimerInterval
                                                               target:self
                                                             selector:@selector(advanceTimer:)
                                                             userInfo:nil
                                                              repeats:YES];
}

#pragma mark -
#pragma mark Private

- (void)advanceTimer:(NSTimer *)timer {
    self.counter--;
    
    if (self.counter < 0) {
        [timer invalidate];
    }
}

@end
