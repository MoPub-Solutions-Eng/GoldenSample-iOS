//
//  MPMockChartboostRewardedVideoCustomEvent.m
//  MoPubSDK
//
//  Copyright © 2017 MoPub. All rights reserved.
//

#import "MPMockChartboostRewardedVideoCustomEvent.h"
#import "MPRewardedVideoCustomEvent+Caching.h"

static BOOL gInitialized = NO;

@implementation MPMockChartboostRewardedVideoCustomEvent

+ (BOOL)isSdkInitialized {
    return gInitialized;
}

+ (void)reset {
    gInitialized = NO;
}

- (void)initializeSdkWithParameters:(NSDictionary *)parameters {
    gInitialized = YES;
}

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info {
    [self setCachedInitializationParameters:info];
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}

@end
