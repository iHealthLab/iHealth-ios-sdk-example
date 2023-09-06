//
//  DeviceAM6FindPhoneUtils.m
//  iHealthDemoCode
//
//  Created by Spring on 2023/6/27.
//  Copyright © 2023 iHealth Demo Code. All rights reserved.
//

#import "DeviceAM6FindPhoneUtils.h"

#import <AVFoundation/AVFoundation.h>

static DeviceAM6FindPhoneUtils *am6_fine_phone_utils = nil;
static dispatch_once_t once;
@interface DeviceAM6FindPhoneUtils ()
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation DeviceAM6FindPhoneUtils

+ (DeviceAM6FindPhoneUtils *)shareInstance{
    dispatch_once(&once, ^{
        am6_fine_phone_utils = [[self alloc] init];
    });
    return am6_fine_phone_utils;
}
- (AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        [audioSession setActive:YES error:nil];
                
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"FindPhoneAudio" withExtension:@"mp3"];
//        NSURL *url = [NSURL fileURLWithPath:[[WZLatteBundle currentBundle]pathForResource:@"FindPhoneAudio" ofType:@"mp3"]];
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _audioPlayer.volume = 1.0;
        _audioPlayer.numberOfLoops = 1;
        [_audioPlayer prepareToPlay];
    }
    return _audioPlayer;
}
- (void)play{
    if (self.audioPlayer.isPlaying) {
        return;
    }
    [self.audioPlayer play];
    [self cellPhoneShakeMethod];
}
- (void)stop{
    if (!_audioPlayer.isPlaying) {
        return;
    }
    self.audioPlayer.currentTime = 0;
    [self.audioPlayer stop];
    
}
- (void)cellPhoneShakeMethod {
    AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
        if (self.audioPlayer.isPlaying) {
            [self cellPhoneShakeMethod];
        }
    });
}

@end
