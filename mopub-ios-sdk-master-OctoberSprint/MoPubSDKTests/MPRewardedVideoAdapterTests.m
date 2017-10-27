//
//  MPRewardedVideoAdapterTests.m
//  MoPubSDK
//
//  Copyright © 2017 MoPub. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MPConstants+Testing.h"
#import "MPRewardedVideoAdapter.h"
#import "MPRewardedVideoAdapterDelegateHandler.h"
#import "MPRewardedVideoAdapter+Testing.h"
#import "MPMoPubRewardedVideoCustomEvent.h"

static NSTimeInterval const kTestTimeout = 2;

@interface MPRewardedVideoAdapterTests : XCTestCase

@property MPRewardedVideoAdapterDelegateHandler *delegateHandler;
@property MPRewardedVideoAdapter *adapter;

@end

@implementation MPRewardedVideoAdapterTests

- (void)setUp {
    [super setUp];

    self.delegateHandler = [[MPRewardedVideoAdapterDelegateHandler alloc] init];
    self.adapter = [[MPRewardedVideoAdapter alloc] initWithDelegate:self.delegateHandler];
}

// be sure `trackImpression` marks `hasTrackedImpression` as `YES`
- (void)testTrackImpressionSetsHasTrackedImpressionCorrectly {
    XCTAssertFalse(self.adapter.hasTrackedImpression);
    [self.adapter trackImpression];
    XCTAssertTrue(self.adapter.hasTrackedImpression);
}

// test that ad expires if no impression is tracked within the given limit, and be sure the callback is called
- (void)testAdWillExpireWithNoImpression {
    MPMoPubRewardedVideoCustomEvent *customEvent = [[MPMoPubRewardedVideoCustomEvent alloc] init];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for expiration delegate method to be triggered"];

    __block BOOL didExpire = NO;
    self.delegateHandler.rewardedVideoDidExpire = ^(MPRewardedVideoAdapter *adapter) {
        didExpire = YES;
        [expectation fulfill];
    };

    [self.adapter rewardedVideoDidLoadAdForCustomEvent:customEvent];

    [self waitForExpectationsWithTimeout:kTestTimeout handler:^(NSError *error) {
        XCTAssertNil(error);
    }];

    XCTAssertTrue(didExpire);
    XCTAssertTrue(self.adapter.hasExpired);
    XCTAssertFalse(self.adapter.hasTrackedImpression);
}

// test ad does not expire if impression is tracked
- (void)testAdWillNotExpireIfImpressionIsTracked {
    MPMoPubRewardedVideoCustomEvent *customEvent = [[MPMoPubRewardedVideoCustomEvent alloc] init];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for expiration interval to elapse"];

    __block BOOL didExpire = NO;
    self.delegateHandler.rewardedVideoDidExpire = ^(MPRewardedVideoAdapter *adapter) {
        didExpire = YES;
    };

    [self.adapter rewardedVideoDidLoadAdForCustomEvent:customEvent];
    [self.adapter trackImpression];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(([MPConstants adsExpirationInterval] + 0.5) * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   ^{
                       [expectation fulfill];
                   });

    [self waitForExpectationsWithTimeout:kTestTimeout handler:^(NSError *error) {
        XCTAssertNil(error);
    }];

    XCTAssertTrue(self.adapter.hasTrackedImpression);
    XCTAssertFalse(didExpire);
    XCTAssertFalse(self.adapter.hasExpired);
}

// test ad never expires if not mopub-specific custom event
- (void)testAdNeverExpiresIfNotMoPubCustomEvent {
    MPRewardedVideoCustomEvent *customEvent = [[MPRewardedVideoCustomEvent alloc] init];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for expiration interval to elapse"];

    __block BOOL didExpire = NO;
    self.delegateHandler.rewardedVideoDidExpire = ^(MPRewardedVideoAdapter *adapter) {
        didExpire = YES;
    };

    [self.adapter rewardedVideoDidLoadAdForCustomEvent:customEvent];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(([MPConstants adsExpirationInterval] + 0.5) * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   ^{
                       [expectation fulfill];
                   });

    [self waitForExpectationsWithTimeout:kTestTimeout handler:^(NSError *error) {
        XCTAssertNil(error);
    }];

    XCTAssertFalse(self.adapter.hasTrackedImpression);
    XCTAssertFalse(didExpire);
    XCTAssertFalse(self.adapter.hasExpired);
}

@end
