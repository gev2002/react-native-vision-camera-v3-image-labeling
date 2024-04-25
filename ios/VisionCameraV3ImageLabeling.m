#import <MLKitImageLabeling/MLKitImageLabeling.h>
#import <MLKitImageLabelingCommon/MLKImageLabel.h>
#import <MLKitImageLabelingCommon/MLKImageLabeler.h>
#import <VisionCamera/FrameProcessorPlugin.h>
#import <VisionCamera/FrameProcessorPluginRegistry.h>
#import <VisionCameraProxyHolder.h>
#import <VisionCamera/Frame.h>
@import MLKitVision;


@interface VisionCameraV3ImageLabeling : FrameProcessorPlugin
@property (nonatomic, strong) MLKImageLabeler *labeler;
@property (nonatomic, assign) CGFloat minConfidence;
@end

@implementation VisionCameraV3ImageLabeling

- (instancetype)initWithProxy:(VisionCameraProxyHolder*)proxy
                   withOptions:(NSDictionary* _Nullable)options {
    self = [super initWithProxy:proxy withOptions:options];
    if (self) {
        NSNumber *minConfidence = options[@"minConfidence"];
        if (minConfidence && [minConfidence floatValue] < 1.0 && [minConfidence floatValue] > 0.0) {
            self.minConfidence = [minConfidence floatValue];
            MLKImageLabelerOptions *labelerOptions = [[MLKImageLabelerOptions alloc] init];
            labelerOptions.confidenceThreshold = [NSNumber numberWithFloat:self.minConfidence];
            self.labeler = [MLKImageLabeler imageLabelerWithOptions:labelerOptions];
        }
    }
    return self;
}

- (NSArray *)callback:(Frame* _Nonnull)frame
         withArguments:(NSDictionary* _Nullable)arguments {
    CMSampleBufferRef buffer = frame.buffer;
    MLKVisionImage *image = [[MLKVisionImage alloc] initWithBuffer:buffer];
    UIImageOrientation orientation = frame.orientation;
    image.orientation = orientation;
    NSMutableArray *data = [NSMutableArray array];
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.labeler processImage:image
         completion:^(NSArray<MLKImageLabel *> *labels,NSError *error){
            if (error || !labels) {
                dispatch_group_leave(dispatchGroup);
                return;
            }
            for (MLKImageLabel *label in labels) {
                NSString *labelText = label.text;
                float confidence = label.confidence;
                NSDictionary *labelInfo = @{@"confidence": @(confidence),@"label": labelText};
                [data addObject:labelInfo];
            }
            dispatch_group_leave(dispatchGroup);
        }];
    });
    dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER);
    return data;
}

VISION_EXPORT_FRAME_PROCESSOR(VisionCameraV3ImageLabeling, scanImage)

@end
