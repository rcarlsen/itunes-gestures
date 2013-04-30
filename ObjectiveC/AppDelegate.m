    /******************************************************************************\
* Copyright (C) 2012-2013 Leap Motion, Inc. All rights reserved.               *
* Leap Motion proprietary and confidential. Not for distribution.              *
* Use subject to the terms of the Leap Motion SDK Agreement available at       *
* https://developer.leapmotion.com/sdk_agreement, or another agreement         *
* between Leap Motion and you, your company or other organization.             *
\******************************************************************************/

#import "AppDelegate.h"
#import "Sample.h"
#import "iTunes.h"

@implementation AppDelegate

// Xcode 4.2 warns if we do not explicitly synthesize
@synthesize window = _window;
@synthesize sample = _sample; // must retain for notifications

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _sample = [[Sample alloc] init];
    [_sample run];
    
    iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    _iTunes = iTunes;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(play:)
                                                 name:kScreenTapNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeUp:)
                                                 name:kCircleClockwiseNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeDown:)
                                                 name:kCircleCounterClockwiseNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nextTrack:)
                                                 name:kSwipeRightNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(previousTrack:)
                                                 name:kSwipeLeftNotification
                                               object:nil];
    
    [_gestureLabel setStringValue:@""];
}


-(void)volumeUp:(NSNotification*)notification;
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [_gestureLabel setStringValue:@"Clockwise Circle"];
    
    if ( [_iTunes isRunning] ) {
        int rampVolume, originalVolume;
        originalVolume = (int)[_iTunes soundVolume];
        rampVolume = MIN(100, originalVolume + 1);
        
        [_iTunes setSoundVolume:rampVolume];
    }
}


-(void)volumeDown:(NSNotification*)notification;
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [_gestureLabel setStringValue:@"Counter-Clockwise Circle"];
    
    if ( [_iTunes isRunning] ) {
        int rampVolume, originalVolume;
        originalVolume = (int)[_iTunes soundVolume];
        rampVolume = MAX(0, originalVolume - 1);
        
        [_iTunes setSoundVolume:rampVolume];
    }
}

-(void)nextTrack:(NSNotification*)notification;
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [_gestureLabel setStringValue:@"Swipe Right"];
    
    if ( [_iTunes isRunning] ) {
        [_iTunes nextTrack];
    }
}


-(void)previousTrack:(NSNotification*)notification;
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [_gestureLabel setStringValue:@"Swipe Left"];
    
    if ( [_iTunes isRunning] ) {
        [_iTunes previousTrack];
    }
}

- (void)play:(id)sender {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [_gestureLabel setStringValue:@"Screen Tap"];
    
    if ( [_iTunes isRunning] ) {
        [_iTunes playpause];
        
//        int rampVolume, originalVolume;
//        originalVolume = (int)[_iTunes soundVolume];
//        
//        [_iTunes setSoundVolume:0];
//        [_iTunes playOnce:NO];
//        
//        for (rampVolume = 0; rampVolume < originalVolume; rampVolume += originalVolume / 16) {
//            [_iTunes setSoundVolume: rampVolume];
//            /* pause 1/10th of a second (100,000 microseconds) between adjustments. */
//            usleep(100000);
//        }
//        [_iTunes setSoundVolume:originalVolume];
    }
}

@end
