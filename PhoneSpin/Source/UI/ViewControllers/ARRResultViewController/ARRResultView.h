//
//  ARRResultView.h
//  PhoneSpin
//
//  Created by Igor Arsenkin on 04.12.15.
//  Copyright © 2015 Igor Arsenkin. All rights reserved.
//

#import "ARRView.h"

@class ARRScoreModel;

@interface ARRResultView : ARRView
@property (nonatomic, weak)     IBOutlet UILabel    *achievement;
@property (nonatomic, weak)     IBOutlet UILabel    *nameOfAchievement;

@property (nonatomic, strong)   ARRScoreModel       *scoreModel;

@end
