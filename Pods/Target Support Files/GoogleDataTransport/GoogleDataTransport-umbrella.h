#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GDTCORConsoleLogger.h"
#import "GDTCOREndpoints.h"
#import "GDTCOREventTransformer.h"
#import "GoogleDataTransport.h"

FOUNDATION_EXPORT double GoogleDataTransportVersionNumber;
FOUNDATION_EXPORT const unsigned char GoogleDataTransportVersionString[];

