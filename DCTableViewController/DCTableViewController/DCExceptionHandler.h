#import <Foundation/Foundation.h>

@interface DCExceptionHandler : NSObject

+ (BOOL)catchException:(void(^)())tryBlock error:(__autoreleasing NSError **)error;

@end
