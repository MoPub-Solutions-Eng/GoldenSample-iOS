//
//  MPAdInfo.m
//  MoPub
//
//  Copyright (c) 2013 MoPub. All rights reserved.
//

#import "MPAdInfo.h"

#import <Foundation/Foundation.h>

@implementation MPAdInfo

+ (NSDictionary *)supportedAddedAdTypes
{
    static NSDictionary *adTypes = nil;

    static dispatch_once_t once;
    dispatch_once(&once, ^{
        adTypes = @{@"Banner":@(MPAdInfoBanner), @"Interstitial":@(MPAdInfoInterstitial), @"MRect":@(MPAdInfoMRectBanner), @"Leaderboard":@(MPAdInfoLeaderboardBanner), @"Native":@(MPAdInfoNative), @"Rewarded Video":@(MPAdInfoRewardedVideo)};
    });

    return adTypes;
}

+ (NSArray *)bannerAds
{
    NSMutableArray *ads = [NSMutableArray array];

    [ads addObjectsFromArray:@[
                               [MPAdInfo infoWithTitle:@"HTML Banner Ad" ID:@"cad245d57f7a4374b546cdf2c0c8f96a" type:MPAdInfoBanner],
                               [MPAdInfo infoWithTitle:@"MRAID Banner Ad" ID:@"23b49916add211e281c11231392559e4" type:MPAdInfoBanner],
                               [MPAdInfo infoWithTitle:@"HTML MRECT Banner Ad" ID:@"2aae44d2ab91424d9850870af33e5af7" type:MPAdInfoMRectBanner],
                               ]];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [ads addObject:[MPAdInfo infoWithTitle:@"HTML Leaderboard Banner Ad" ID:@"d456ea115eec497ab33e02531a5efcbc" type:MPAdInfoLeaderboardBanner]];
    }

    // 3rd Party Networks
#if CUSTOM_EVENTS_ENABLED
    [ads addObject:[MPAdInfo infoWithTitle:@"Facebook" ID:@"0575b051596745b6a0909fe741f6aac7" type:MPAdInfoBanner]];
    [ads addObject:[MPAdInfo infoWithTitle:@"Flurry RTB Banner Ad" ID:@"b827dff81325466e95cc6d475f207fb3" type:MPAdInfoBanner]];
    [ads addObject:[MPAdInfo infoWithTitle:@"Google AdMob" ID:@"c9c2ea9a8e1249b68496978b072d2fd2" type:MPAdInfoBanner]];
    [ads addObject:[MPAdInfo infoWithTitle:@"Millennial" ID:@"cad245d57f7a4374b546cdf2c0c8f96a" type:MPAdInfoBanner]];
#endif

    return ads;
}

+ (NSArray *)interstitialAds
{
    return @[
             [MPAdInfo infoWithTitle:@"HTML Interstitial Ad" ID:@"4f117153f5c24fa6a3a92b818a5eb630" type:MPAdInfoInterstitial],
             [MPAdInfo infoWithTitle:@"MRAID Interstitial Ad" ID:@"3aba0056add211e281c11231392559e4" type:MPAdInfoInterstitial],

    // 3rd Party Networks
    #if CUSTOM_EVENTS_ENABLED
             [MPAdInfo infoWithTitle:@"Chartboost" ID:@"a425ff78959911e295fa123138070049" type:MPAdInfoInterstitial],
             [MPAdInfo infoWithTitle:@"Facebook" ID:@"d439571168f64021aeb50ba53d83ad8c" type:MPAdInfoInterstitial],
             [MPAdInfo infoWithTitle:@"Flurry Interstitial Ad" ID:@"5124d5ff5e3944d2ab8ad496b87a0978" type:MPAdInfoInterstitial],
             [MPAdInfo infoWithTitle:@"Flurry RTB Interstitial Ad" ID:@"49960150e2874e9294105af00a77b85c" type:MPAdInfoInterstitial],
             [MPAdInfo infoWithTitle:@"Google AdMob" ID:@"4a488029dafb423790423370dc5835c0" type:MPAdInfoInterstitial],
             [MPAdInfo infoWithTitle:@"Millennial" ID:@"93c3fc00fbb54825b6a33b20927315f7" type:MPAdInfoInterstitial],
             [MPAdInfo infoWithTitle:@"Tapjoy" ID:@"83b8ccba00de4d27a2b6d97a3a0d80ce" type:MPAdInfoInterstitial],
             [MPAdInfo infoWithTitle:@"Vungle" ID:@"62b74f131ddc49c0bd8b22cf6e8a0411" type:MPAdInfoInterstitial],
    #endif
             ];
}

+ (NSArray *)rewardedVideoAds
{
    return @[
             [MPAdInfo infoWithTitle:@"Rewarded Video Ad" ID:@"3753508606e54da4b4cc5bc474844bd7" type:MPAdInfoRewardedVideo],
             [MPAdInfo infoWithTitle:@"Rewarded Rich Media Ad" ID:@"98c29e015e7346bd9c380b1467b33850" type:MPAdInfoRewardedVideo],
    // 3rd Party Networks
    #if CUSTOM_EVENTS_ENABLED
             [MPAdInfo infoWithTitle:@"MM" ID:@"2e3e02b7381e4ba19c6cf9ef506ff5af" type:MPAdInfoRewardedVideo],
             [MPAdInfo infoWithTitle:@"AdMob" ID:@"0ceacb73895748ceadf0048a1f989855" type:MPAdInfoRewardedVideo],
             [MPAdInfo infoWithTitle:@"Chartboost" ID:@"8be0bb08fb4f4e90a86416c29c235d4a" type:MPAdInfoRewardedVideo],
             [MPAdInfo infoWithTitle:@"Facebook" ID:@"9204bbf695b24f26a9a8b7066e712c10" type:MPAdInfoRewardedVideo],
             [MPAdInfo infoWithTitle:@"Tapjoy" ID:@"db8b4f8134664c4d91d3196a53c5aad9" type:MPAdInfoRewardedVideo],
             [MPAdInfo infoWithTitle:@"Adcolony" ID:@"5fc475d65f014130acb556634b4af4cc" type:MPAdInfoRewardedVideo],
             [MPAdInfo infoWithTitle:@"Vungle" ID:@"39f2a3f82f834d3fba1819d8b22f49cc" type:MPAdInfoRewardedVideo],
    #endif
             ];
}

+ (NSArray *)nativeAds
{
    return @[
             [MPAdInfo infoWithTitle:@"Native Ad" ID:@"76a3fefaced247959582d2d2df6f4757" type:MPAdInfoNative],
             [MPAdInfo infoWithTitle:@"Native Video Ad" ID:@"b2b67c2a8c0944eda272ed8e4ddf7ed4" type:MPAdInfoNative],
             [MPAdInfo infoWithTitle:@"Native Ad (CollectionView Placer)" ID:@"76a3fefaced247959582d2d2df6f4757" type:MPAdInfoNativeInCollectionView],
             [MPAdInfo infoWithTitle:@"Native Ad (TableView Placer)" ID:@"76a3fefaced247959582d2d2df6f4757" type:MPAdInfoNativeTableViewPlacer],
             [MPAdInfo infoWithTitle:@"Native Video Ad (TableView Placer)" ID:@"b2b67c2a8c0944eda272ed8e4ddf7ed4" type:MPAdInfoNativeTableViewPlacer],

    // 3rd Party Networks
    #if CUSTOM_EVENTS_ENABLED
             [MPAdInfo infoWithTitle:@"Facebook" ID:@"5f1f7a540671408c954eb8f0beefd239" type:MPAdInfoNative],
             [MPAdInfo infoWithTitle:@"Flurry Native Ad" ID:@"1023187dc1984ec28948b49220e1e3d4" type:MPAdInfoNative],
             [MPAdInfo infoWithTitle:@"Flurry Native Video Ad" ID:@"86fa46ac76c546178f1a5774bad66103" type:MPAdInfoNative],
             [MPAdInfo infoWithTitle:@"Flurry Native Ad (TableView Placer)" ID:@"1023187dc1984ec28948b49220e1e3d4" type:MPAdInfoNativeTableViewPlacer],
             [MPAdInfo infoWithTitle:@"Google AdMob" ID:@"e1598f16673a409e95c66e79ba592aeb" type:MPAdInfoNative],
             [MPAdInfo infoWithTitle:@"Millennial" ID:@"69b2d2cfda6a4d07aefa1847066c89ab" type:MPAdInfoNative],
    #endif
             ];
}

+ (MPAdInfo *)infoWithTitle:(NSString *)title ID:(NSString *)ID type:(MPAdInfoType)type {
    MPAdInfo *info = [[MPAdInfo alloc] init];
    info.title = title;
    info.ID = ID;
    info.type = type;
    return info;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self != nil)
    {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.keywords = [aDecoder decodeObjectForKey:@"keywords"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:((self.keywords != nil) ? self.keywords : @"") forKey:@"keywords"];
}

@end
