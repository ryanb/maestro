#import <Cocoa/Cocoa.h>
#import <CoreMIDI/MIDIServices.h>

@interface MIDIUtility : NSObject {

}

+ (void)setup;
+ (BOOL)isKeyPressed:(int)key;

@end
