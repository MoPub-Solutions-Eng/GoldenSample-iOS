//
//  FacebookRewardedVideoCustomEvent.m
//
//  Created by Mopub on 4/12/17.
//


#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import "FacebookRewardedVideoCustomEvent.h"

#import "MPInstanceProvider.h"
#import "MPLogging.h"
#import "MoPub.h"
#import "MPRewardedVideoReward.h"

@interface MPInstanceProvider (FacebookRewardedVideos)

- (FBRewardedVideoAd *)buildFBRewardedVideoAdWithPlacementID:(NSString *)placementID
                                                  delegate:(id<FBRewardedVideoAdDelegate>)delegate;

@end

@implementation MPInstanceProvider (FacebookRewardedVideos)

- (FBRewardedVideoAd *)buildFBRewardedVideoAdWithPlacementID:(NSString *)placementID
                                                  delegate:(id<FBRewardedVideoAdDelegate>)delegate
{
    FBRewardedVideoAd *rewardedVideoAd = [[FBRewardedVideoAd alloc] initWithPlacementID:placementID];
    rewardedVideoAd.delegate = delegate;
    return rewardedVideoAd;
}

@end


@interface FacebookRewardedVideoCustomEvent () <FBRewardedVideoAdDelegate>

@property (nonatomic, strong) FBRewardedVideoAd *fbRewardedVideoAd;


@end

@implementation FacebookRewardedVideoCustomEvent

- (void)initializeSdkWithParameters:(NSDictionary *)parameters {
    // No SDK initialization method provided.
}

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info {
    if (![info objectForKey:@"placement_id"]) {
        MPLogError(@"Placement ID is required for Facebook Rewarded Video ad");
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:nil];
        return;
    }
    MPLogInfo(@"Requesting Facebook Rewarded Video ad");

    self.fbRewardedVideoAd =
    [[MPInstanceProvider sharedProvider] buildFBRewardedVideoAdWithPlacementID: [info objectForKey:@"placement_id"] delegate:self];

    [self.fbRewardedVideoAd loadAd];
}

//Verify that the rewarded video is precached
- (BOOL)hasAdAvailable
{
    return (self.fbRewardedVideoAd != nil && self.fbRewardedVideoAd.isAdValid);
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController
{
    if(![self hasAdAvailable])
    {
        MPLogError(@"Facebook rewarded video ad was not available");
        NSError *error = [NSError errorWithDomain:MoPubRewardedVideoAdsSDKDomain code:MPRewardedVideoAdErrorNoAdsAvailable userInfo:nil];
        [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:error];
    }
    else
    {
        MPLogInfo(@"Facebook rewarded video ad will be presented");
        [self.delegate rewardedVideoWillAppearForCustomEvent:self];
        [self.fbRewardedVideoAd showAdFromRootViewController:viewController];
        MPLogInfo(@"Facebook rewarded video ad was presented");
        [self.delegate rewardedVideoDidAppearForCustomEvent:self];
    }
}

-(void)dealloc{
    _fbRewardedVideoAd.delegate = nil;
}

#pragma mark FBRewardedVideoAdDelegate methods

/*!
 @method

 @abstract
 Sent after an ad has been clicked by the person.

 @param rewardedVideoAd An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdDidClick:(FBRewardedVideoAd *)rewardedVideoAd
{
    MPLogInfo(@"Facebook rewarded video ad was clicked");
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self ];
}

/*!
 @method

 @abstract
 Sent when an ad has been successfully loaded.

 @param rewardedVideoAd An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdDidLoad:(FBRewardedVideoAd *)rewardedVideoAd
{
    MPLogInfo(@"Facebook rewarded video ad was loaded. Can present now.");
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self ];
}

/*!
 @method

 @abstract
 Sent after an FBRewardedVideoAd object has been dismissed from the screen, returning control
 to your application.

 @param rewardedVideoAd An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdDidClose:(FBRewardedVideoAd *)rewardedVideoAd
{
    MPLogInfo(@"Facebook rewarded video ad is dismissed.");
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
}

/*!
 @method

 @abstract
 Sent immediately before an FBRewardedVideoAd object will be dismissed from the screen.

 @param rewardedVideoAd An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdWillClose:(FBRewardedVideoAd *)rewardedVideoAd
{
    MPLogInfo(@"Facebook rewarded video ad will be dismissed.");
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
}

/*!
 @method

 @abstract
 Sent after an FBRewardedVideoAd fails to load the ad.

 @param rewardedVideoAd An FBRewardedVideoAd object sending the message.
 @param error An error object containing details of the error.
 */
- (void)rewardedVideoAd:(FBRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    MPLogInfo(@"Facebook rewarded video ad failed to load with error.");
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
}

/*!
 @method

 @abstract
 Sent after the FBRewardedVideoAd object has finished playing the video successfully.
 Reward the user on this callback.

 @param rewardedVideoAd An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdComplete:(FBRewardedVideoAd *)rewardedVideoAd
{
    MPLogInfo(@"Facebook rewarded video ad has finished playing successfully");

    // Passing the reward type and amount as unspecified. Set the reward value in mopub UI.
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:[[MPRewardedVideoReward alloc] initWithCurrencyAmount:@(kMPRewardedVideoRewardCurrencyAmountUnspecified)]];

}

/*!
 @method

 @abstract
 Sent immediately before the impression of an FBRewardedVideoAd object will be logged.

 @param rewardedVideoAd An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdWillLogImpression:(FBRewardedVideoAd *)rewardedVideoAd
{
    MPLogInfo(@"Facebook rewarded video has started playing and hence logging impression");
}

@end



