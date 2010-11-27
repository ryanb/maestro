#import <Cocoa/Cocoa.h>
#import <CoreMIDI/MIDIServices.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h> //for AUGraph

@interface MIDIUtility : NSObject {

}

+ (void)setup;
+ (void)teardown;
+ (BOOL)isKeyPressed:(int)key;

@end
