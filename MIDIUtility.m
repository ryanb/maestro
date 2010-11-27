#import "MIDIUtility.h"

BOOL keys[200];
AUGraph graph = 0;
AudioUnit synthUnit;

// some MIDI constants:
enum {
	kMidiMessage_ControlChange 		= 0xB,
	kMidiMessage_ProgramChange 		= 0xC,
	kMidiMessage_BankMSBControl 	= 0,
	kMidiMessage_BankLSBControl		= 32,
	kMidiMessage_NoteOn 			= 0x9
};


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
				int		velocity;
				
				if (packet->data[i+2] > 0) {
					keyDown = YES;
				} else {
					keyDown = NO;
				}
				
				key = packet->data[i+1];
				velocity = packet->data[i+2];
				keys[key] = keyDown;
				
				if (keyDown) {
					// Notify with MIDIKeyDownNotification
					[[NSNotificationCenter defaultCenter] postNotificationName:@"MIDIKeyDownNotification" object:[NSNumber numberWithInt:key]];
					// NSLog(@"Down: %d at %d", key, velocity);
				} else {
					// Notify with MIDIKeyUpNotification
					[[NSNotificationCenter defaultCenter] postNotificationName:@"MIDIKeyUpNotification" object:[NSNumber numberWithInt:key]];
					// NSLog(@"Up: %d at %d", key);
					velocity = 0;
				}
				// Play note
				MusicDeviceMIDIEvent(synthUnit, kMidiMessage_NoteOn << 4, key, velocity, 0);
			}
		}
		
		packet = MIDIPacketNext(packet);
	}
	
	[pool release];
}

// from PlaySoftMIDI sample code
void createAUGraph(AUGraph *outGraph, AudioUnit *outSynth)
{
	//create the nodes of the graph
	AUNode synthNode, limiterNode, outNode;
	
	AudioComponentDescription cd;
	cd.componentManufacturer = kAudioUnitManufacturer_Apple;
	cd.componentFlags = 0;
	cd.componentFlagsMask = 0;
	
	NewAUGraph(outGraph);
	cd.componentType = kAudioUnitType_MusicDevice;
	cd.componentSubType = kAudioUnitSubType_DLSSynth;
	
	AUGraphAddNode(*outGraph, &cd, &synthNode);
	cd.componentType = kAudioUnitType_Effect;
	cd.componentSubType = kAudioUnitSubType_PeakLimiter;
	
	AUGraphAddNode(*outGraph, &cd, &limiterNode);
	cd.componentType = kAudioUnitType_Output;
	cd.componentSubType = kAudioUnitSubType_DefaultOutput;
	
	AUGraphAddNode(*outGraph, &cd, &outNode);
	AUGraphOpen(*outGraph);
	AUGraphConnectNodeInput(*outGraph, synthNode, 0, limiterNode, 0);
	AUGraphConnectNodeInput(*outGraph, limiterNode, 0, outNode, 0);
	
	// ok we're good to go - get the Synth Unit...
	AUGraphNodeInfo(*outGraph, synthNode, 0, outSynth);
}


@implementation MIDIUtility

+ (void)setup
{
	int i, sourceCount;
	MIDIPortRef inPort;
	MIDIClientRef client;
	
	createAUGraph(&graph, &synthUnit);
	AUGraphInitialize(graph);
	MusicDeviceMIDIEvent(synthUnit, kMidiMessage_ControlChange << 4, kMidiMessage_BankMSBControl, 0, 0/*sample offset*/);
	MusicDeviceMIDIEvent(synthUnit, kMidiMessage_ProgramChange << 4, 0/*prog change num*/, 0, 0/*sample offset*/);
	CAShow(graph); // prints out the graph so we can see what it looks like...
	AUGraphStart(graph);
	
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

+ (void)teardown
{
	if (graph) {
		AUGraphStop(graph); // stop playback - AUGraphDispose will do that for us but just showing you what to do
		DisposeAUGraph(graph);
	}
}


+ (BOOL)isKeyPressed:(int)key
{
	return keys[key];
}

@end