#import <Foundation/Foundation.h>
#import <VisionCamera/FrameProcessorPlugin.h>
#import <VisionCamera/FrameProcessorPluginRegistry.h>
#import <VisionCamera/Frame.h>


#if __has_include("VisionCameraImageLabeling/VisionCameraImageLabeling-Swift.h")
#import "VisionCameraImageLabeling/VisionCameraImageLabeling-Swift.h"
#else
#import "VisionCameraImageLabeling-Swift.h"
#endif

@interface VisionCameraImageLabeling (FrameProcessorPluginLoader)
@end

@implementation VisionCameraImageLabeling (FrameProcessorPluginLoader)
+ (void) load {
  [FrameProcessorPluginRegistry addFrameProcessorPlugin:@"scanImage"
    withInitializer:^FrameProcessorPlugin*(VisionCameraProxyHolder* proxy, NSDictionary* options) {
    return [[VisionCameraImageLabeling alloc] initWithProxy:proxy withOptions:options];
  }];
}
@end
