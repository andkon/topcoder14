//
//  NclWrapper.h
//  iOSBasicExample
//
//  Created by Dave Rai on 2014-10-31.
//  Copyright (c) 2014 Bionym. All rights reserved.
//


// This class is created to encapsulate the 'C' based call back mechanism for NCL
// Currently, the wrapper is written for the iOSBasicExample, but may be extended
// in the future to be a more generic Objective-C wrapper for NCL
// The wrapper currently assumes only one Nymi is ever provisioined


#include "ncl.h"


// Protocol client objects have to implement in order to get callbacks from NCL
@protocol NclEventProtocol <NSObject>

// client code should copy event data if required. Event data is deallocated
// as soon as this call completes
-(void) incomingNclEvent: (NclEvent*) nclEvent;

@end


// Wrapper class - since this is currently for a very simple example,
// all methods are class methods for now

@interface NclWrapper : NSObject {
    @public FILE* errorStream;
}

// Set the object that will respond to events
// As soon as this method is called, NCL is initialized and the initialize event is being awaited
-(void) setNclDelegate: (id <NclEventProtocol>) nclDelegate;


// Once called, the delegate is informed only of he events of the given type, until this method is called again
// with an event of a different type. Prior to being called, only initialize events are reported
// This warpper is designed for working with a single nymi and the very basic flow
-(void) waitNclForEvent;

-(void) setEventTypeToWaitFor: (NclEventType) eventType;


// methods to take action using ncl
// for now, these are pretty well pass through. It is up to the calling code to call these
// in the right order. Return results are dispatched via the delegate that is set

- (void) discoverNymi;

- (void) agreeNymi: (int) withHandle;

- (void) provisionNymi : (int) withHandle;

- (void) findNymi;

- (void) validateNymi: (int) withHandle;

- (void) disconnectNymi: (int) withHandle;

- (void) stopScan;

@end