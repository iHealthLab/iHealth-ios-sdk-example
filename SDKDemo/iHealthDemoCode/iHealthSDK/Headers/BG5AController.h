//
//  BG5AController.h
//  iHealthDeviceSDK
//
//  Created by Spring on 2023/9/13.
//

#import <Foundation/Foundation.h>
@class BG5A;

NS_ASSUME_NONNULL_BEGIN

@interface BG5AController : NSObject
/**
 * Initialize BG5A controller class
 */
+(BG5AController *)shareIHBG5AController;

/**
 * Get all BG5A instance,use hsInstance to call BG related communication methods.
 */
-(NSArray *)getAllCurrentBG5AInstace;

/// Get BG5A Instance
/// @param mac mac or serial number
/// Suggestion: Use weak when defining the object of BG5A. Using strong may cause the object to not be cleaned up when disconnected.
- (nullable BG5A *)getInstanceWithMac:(NSString*)mac;
@end

NS_ASSUME_NONNULL_END
