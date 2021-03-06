//
//  ARRStartView.m
//  PhoneSpin
//
//  Created by Igor Arsenkin on 25.11.15.
//  Copyright © 2015 Igor Arsenkin. All rights reserved.
//

#import "ARRStartView.h"

#import "ARRContentModel.h"
#import "ARRScoreModel.h"

@implementation ARRStartView

#pragma mark -
#pragma mark Initializations and Deallocation

- (void)dealloc {
    self.contentModel = nil;
    self.scoreModel = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentModel = [ARRContentModel new];
    self.scoreModel = [ARRScoreModel sharedScoreModel];
}

#pragma mark -
#pragma mark Accessors

- (void)setContentModel:(ARRContentModel *)contentModel {
    if (_contentModel != contentModel) {
        _contentModel = contentModel;
        [self fillWithContentModel:contentModel];
        self.subviewsVisible = YES;
    }
}

- (void)setScoreModel:(ARRScoreModel *)scoreModel {
    if (_scoreModel != scoreModel) {
        _scoreModel = scoreModel;
        [self fillWithScoreModel:scoreModel];
        self.subviewsVisible = YES;
    }
}

- (void)setSubviewsVisible:(BOOL)subviewsVisible {
    if (_subviewsVisible != subviewsVisible) {
        _subviewsVisible = subviewsVisible;
        
        NSArray *contentSubviews = self.contentsSubviews;
        for (UIView *view in contentSubviews) {
            view.hidden = !_subviewsVisible;
        }
        
        self.countDownText.hidden = _subviewsVisible;
    }
}

#pragma mark -
#pragma mark Public

- (void)fillWithContentModel:(ARRContentModel *)model {
    self.openingText.text = model.openingText;
    self.achievementText.text = model.achievementText;
    self.spinsText.text = model.spinsText;
    self.contentImageView.image = model.image;
}

- (void)fillWithScoreModel:(ARRScoreModel *)model {
    self.maxAchievement.text = [NSString stringWithFormat:@"%ld", (long)model.highScore];
    self.nameOfAchievement.text = [model achievementNameWithScore:model.highScore];
}

- (void)fillWithCountdownValue:(NSInteger)value {
    self.countDownText.text = [NSString stringWithFormat:@"%ld", (long)value];
}

@end
