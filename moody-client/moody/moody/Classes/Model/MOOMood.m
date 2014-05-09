//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MOOMood.h"
#import "MTLValueTransformer.h"

@interface MOOMood ()

@end

@implementation MOOMood {
    CLLocation *_location;
}

+ (instancetype)moodWithScore:(CGFloat)score location:(CLLocation *)location {
    MOOMood *mood = [MOOMood new];
    mood.latitude = location.coordinate.latitude;
    mood.longtitude = location.coordinate.longitude;
    mood.mood = score;
    mood.timestamp = location.timestamp;
    return mood;
}

- (CLLocation *)location {
    if(!_location){
        _location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longtitude)
                                                 altitude:0
                                       horizontalAccuracy:0
                                         verticalAccuracy:0
                                                   course:0 speed:0
                                                timestamp:self.timestamp];

    }
    return _location;
}

#pragma mark - JSON serialization

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

+ (NSValueTransformer *)timestampJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}



@end