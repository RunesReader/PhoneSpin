//
//  ARRScoreModel.m
//  MovingSticks
//
//  Created by Igor Arsenkin on 15.11.15.
//  Copyright © 2015 Apportable. All rights reserved.
//

#import "ARRScoreModel.h"

static NSString * const kARRKeyForHighScore = @"highScore";

static NSString * const kARRPlistFactor     = @"LevelsFactor";
static NSString * const kARRPlistNames      = @"LevelsNames";
static NSString * const kARRPlistType       = @"plist";

@interface ARRScoreModel ()
@property (nonatomic, assign) NSInteger     highScore;
@property (nonatomic, assign) NSInteger     maxCurrentScore;
@property (nonatomic, strong) NSArray       *levelsFactor;
@property (nonatomic, strong) NSArray       *levelsNames;

@end

@implementation ARRScoreModel

#pragma mark -
#pragma mark Class Method

+ (instancetype)sharedScoreModel {
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
        NSString *path = [[NSBundle mainBundle] pathForResource:kARRPlistFactor ofType:kARRPlistType];
        self.levelsFactor = [NSArray arrayWithContentsOfFile:path];
        path = [[NSBundle mainBundle] pathForResource:kARRPlistNames ofType:kARRPlistType];
        self.levelsNames = [NSArray arrayWithContentsOfFile:path];
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setCurrentScore:(NSInteger)currentScore {
    if (currentScore != _currentScore) {
        _currentScore = currentScore;
        if (_currentScore > self.maxCurrentScore) {
            self.maxCurrentScore = _currentScore;
        }
    }
}

- (void)setMaxCurrentScore:(NSInteger)maxCurrentScore {
    if (maxCurrentScore != _maxCurrentScore) {
        _maxCurrentScore = maxCurrentScore;
        if (_maxCurrentScore > self.highScore) {
            self.highScore = _maxCurrentScore;
        }
    }
}

- (NSInteger)highScore {
    if (0 == _highScore) {
        _highScore = [[NSUserDefaults standardUserDefaults] integerForKey:kARRKeyForHighScore];
    }

    return _highScore;
}

#pragma mark -
#pragma mark Public

- (void)resetMaxCurrentScore {
    self.maxCurrentScore = 0;
}

- (void)save {
    [[NSUserDefaults standardUserDefaults] setInteger:self.highScore forKey:kARRKeyForHighScore];
}

- (NSString *)achievementNameWithScore:(NSInteger)score {
    NSInteger level = [self levelWithScore:score];
    
    return self.levelsNames[level];
}

#pragma mark -
#pragma mark Private

- (NSInteger)levelWithScore:(NSInteger)score {
    NSInteger lastIndex = self.levelsFactor.count - 1;
    for (NSInteger i = lastIndex; i >= 0; i--) {
        NSInteger result = [self.levelsFactor[i] integerValue];
        if (score >= result) {
            return i;
        }
    }
    
    return 0;
}

@end
