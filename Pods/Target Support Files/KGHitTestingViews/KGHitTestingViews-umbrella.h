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

#import "KGHitTesting.h"
#import "KGHitTestingButton.h"
#import "KGHitTestingControl.h"
#import "KGHitTestingHelper.h"
#import "KGHitTestingView.h"
#import "UIView+KGHitTesting.h"

FOUNDATION_EXPORT double KGHitTestingViewsVersionNumber;
FOUNDATION_EXPORT const unsigned char KGHitTestingViewsVersionString[];

