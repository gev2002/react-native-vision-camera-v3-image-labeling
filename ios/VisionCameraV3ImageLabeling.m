#import <MLKitImageLabeling/MLKitImageLabeling.h>
#import <MLKitImageLabelingCommon/MLKImageLabel.h>
#import <MLKitImageLabelingCommon/MLKImageLabeler.h>
#import <VisionCamera/FrameProcessorPlugin.h>
#import <VisionCamera/FrameProcessorPluginRegistry.h>
#import <VisionCamera/VisionCameraProxy.h>
#import <VisionCamera/Frame.h>
@import MLKitVision;

@interface VisionCameraV3ImageLabelingPlugin : FrameProcessorPlugin
@end

@implementation VisionCameraV3ImageLabelingPlugin

- (instancetype _Nonnull)initWithProxy:(VisionCameraProxyHolder*)proxy
                           withOptions:(NSDictionary* _Nullable)options {
  self = [super initWithProxy:proxy withOptions:options];

  return self;
}

- (id _Nullable)callback:(Frame* _Nonnull)frame
           withArguments:(NSDictionary* _Nullable)arguments {
    CMSampleBufferRef buffer = frame.buffer;
    MLKVisionImage *image = [[MLKVisionImage alloc] initWithBuffer:buffer];
    MLKImageLabelerOptions *options = [[MLKImageLabelerOptions alloc] init];
    if (arguments) {
        NSNumber *minConfidence = arguments[@"minConfidence"];
        if (minConfidence != nil && [minConfidence floatValue] < 1.0 && [minConfidence floatValue] > 0.0) {
            options.confidenceThreshold = minConfidence;
        }
    }

    MLKImageLabeler *labeler =[MLKImageLabeler imageLabelerWithOptions:options];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [labeler processImage:image
         completion:^(NSArray<MLKImageLabel *> *labels,NSError *error){
            if (!weakSelf) {
                NSLog(@"Self is nil!");
                return;
            }
            if (error || !labels) {
                dispatch_group_leave(dispatchGroup);
              [NSException raise:@"Error processing Image Labeling" format:@"%@",error];
            }
            for (MLKImageLabel *label in labels) {
                NSString *labelText = label.text;
                float confidence = label.confidence;
                [data setObject:@(confidence) forKey:labelText];
            }
            dispatch_group_leave(dispatchGroup);
        }];
    });
    dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER);
    return data;
}

VISION_EXPORT_FRAME_PROCESSOR(VisionCameraV3ImageLabelingPlugin, scanImage)

@end


