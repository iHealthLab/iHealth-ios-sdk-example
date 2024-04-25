//
//  KD723_V2Controller.h
//
//  Created by dai on 24-02-27.
//  Copyright (c) 2024年 my. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KD723_V2.h"
#import "KD723_V2Controller.h"
@class KD723_V2;


@interface KD723_V2Controller : NSObject
/**
 * Initialize KD723 controller class
 */
+(KD723_V2Controller *_Nullable)shareIHKD723Controller;

/**
 * Get all KD723 instance,use hsInstance to call BP related communication methods.
 */
-(NSArray *_Nullable)getAllCurrentKD723Instace;

/// Get KD723 Instance
/// @param mac mac or serial number
/// Suggestion: Use weak when defining the object of KD723. Using strong may cause the object to not be cleaned up when disconnected.
- (nullable KD723_V2 *)getInstanceWithMac:(NSString*_Nullable)mac;

@end
