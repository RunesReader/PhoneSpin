//
//  ARRResultView.m
//  PhoneSpin
//
//  Created by Igor Arsenkin on 04.12.15.
//  Copyright © 2015 Igor Arsenkin. All rights reserved.
//

#import "ARRResultView.h"

#import "ARRScoreModel.h"

@implementation ARRResultView

#pragma mark -
#pragma mark Deallocation and Initializations

- (void)dealloc {
    self.scoreModel = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.scoreModel = [ARRScoreModel sharedScoreModel];
}

#pragma mark -
#pragma mark Accessors

- (void)setScoreModel:(ARRScoreModel *)scoreModel {
    if (_scoreModel != scoreModel) {
        _scoreModel = scoreModel;
        [self fillWithScoreModel:scoreModel];
    }
}

#pragma mark -
#pragma mark Private

- (void)fillWithScoreModel:(ARRScoreModel *)model {
    self.achievement.text = [NSString stringWithFormat:@"%ld", (long)model.highScore];
    self.nameOfAchievement.text = [model achievementNameWithScore:model.highScore];
}

@end
