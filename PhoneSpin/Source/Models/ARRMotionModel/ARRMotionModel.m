//
//  ARRMotionModel.m
//  PhoneSpin
//
//  Created by Igor Arsenkin on 11.12.15.
//  Copyright © 2015 Igor Arsenkin. All rights reserved.
//

#import "ARRMotionModel.h"

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

@end
