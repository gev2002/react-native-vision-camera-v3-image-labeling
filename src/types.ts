export type {
  Frame,
  FrameProcessor,
  FrameProcessorPlugin,
} from 'react-native-vision-camera';
import type { CameraProps } from 'react-native-vision-camera';
export interface ImageLabelingOptions {
  minConfidence:
    | 0.1
    | 0.01
    | 0.2
    | 0.02
    | 0.3
    | 0.03
    | 0.4
    | 0.04
    | 0.5
    | 0.05
    | 0.6
    | 0.06
    | 0.7
    | 0.07
    | 0.8
    | 0.08
    | 0.9
    | 0.09
    | 1.0;
}

export type CameraTypes = {
  callback: Function;
  options?: ImageLabelingOptions;
} & CameraProps;
