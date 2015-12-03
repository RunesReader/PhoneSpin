//
//  ARRCountdownModel.h
//  PhoneSpin
//
//  Created by Igor Arsenkin on 03.12.15.
//  Copyright © 2015 Igor Arsenkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARRCountdownModel : NSObject
@property (nonatomic, readonly) NSInteger counter;

- (void)startConutdownWithValue:(NSInteger)startValue;

@end
