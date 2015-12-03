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

static const NSTimeInterval kARRTimerInterval   = 1.0;
static const NSInteger      kARRStartDelay      = 3;

@interface ARRStartView ()
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign, getter=areSubviewsVisible)    BOOL    subviewsVisible;

@end

@implementation ARRStartView

#pragma mark -
#pragma mark Initializations and Deallocation

- (void)dealloc {
    self.contentModel = nil;
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

#pragma mark -
#pragma mark Private Accessors

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
    self.maxAchievement.text = [NSString stringWithFormat:@"%d", model.highScore];
    self.nameOfAchievement.text = [model achievementNameWithScore:model.highScore];
}

- (void)fillWithCountdownTimer {
    self.countDownText.text = [NSString stringWithFormat:@"%d", self.counter];
}

#pragma mark -
#pragma mark Countdown Timer

- (void)startConutdownWithValue:(NSInteger)startValue {
    self.counter = startValue;
    [self fillWithCountdownTimer];
    
    __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kARRTimerInterval
                                                               target:self
                                                             selector:@selector(advanceTimer:)
                                                             userInfo:nil
                                                              repeats:YES];
}

- (void)advanceTimer:(NSTimer *)timer {
    self.counter--;
    
    if (self.counter < 0) {
        [timer invalidate];
        
        return;
    }
    
    [self fillWithCountdownTimer];
}

#pragma mark -
#pragma mark Event Handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startConutdownWithValue:kARRStartDelay];
    self.subviewsVisible = NO;
}

@end
