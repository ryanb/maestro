#import "MIDIUtility.h"

BOOL	keys[200];

void readProc(const MIDIPacketList *pktlist, void *refCon, void *connRefCon)
{
	NSAutoreleasePool   *pool;
	int j, i;
	
	objc_registerThreadWithCollector(); // quiet warning about GC starting on thread, 10.6 SDK only
	
	pool = [[NSAutoreleasePool alloc] init];
	
	MIDIPacket *packet = (MIDIPacket *)pktlist->packet;
	for (j=0; j < pktlist->numPackets; j++) {
		
		// only treat note information, ignore cntrol mode info
		if (packet->data[0] < 0xB0) {
			
			// Loop through the notes. Could use some cleaning up
			for (i=0; i < packet->length; i+=3) {
				BOOL	keyDown;
				int		key;
				
				if (packet->data[i] == 144) {
					keyDown = YES;
				} else {
					keyDown = NO;
				}
				
				key = packet->data[i+1];
				keys[key] = keyDown;
				
				if (keyDown) {
					// Notify with MIDIKeyDownNotification
					[[NSNotificationCenter defaultCenter]
					 postNotificationName:@"MIDIKeyDownNotification"
					 object:[NSNumber numberWithInt:key]];
					// NSLog(@"Down: %d", key);
				} else {
					// Notify with MIDIKeyUpNotification
					[[NSNotificationCenter defaultCenter]
					 postNotificationName:@"MIDIKeyUpNotification"
					 object:[NSNumber numberWithInt:key]];
					// NSLog(@"Up: %d", key);
				}
			}
		}
		
		packet = MIDIPacketNext(packet);
	}
	
	[pool release];
}


@implementation MIDIUtility

+ (void)setup
{
	int i, sourceCount;
	MIDIPortRef inPort;
	MIDIClientRef client;
	
	// create client and input port
	// Inputs will be sent to "readProc" method
	MIDIClientCreate(CFSTR("MIDI Echo"), NULL, NULL, &client);
	MIDIInputPortCreate(client, CFSTR("Input port"), readProc, NULL, &inPort);
	
	// open connections from all sources
	sourceCount = MIDIGetNumberOfSources();
	for (i = 0; i < sourceCount; ++i) {
		MIDIPortConnectSource(inPort, MIDIGetSource(i), NULL);
	}
	
	// Report the number of sources
	NSLog(@"%d sources\n", sourceCount);
}


+ (BOOL)isKeyPressed:(int)key
{
	return keys[key];
}

@end
