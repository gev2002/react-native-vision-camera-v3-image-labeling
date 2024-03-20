import { VisionCameraProxy } from 'react-native-vision-camera';
import type {
  Frame,
  FrameProcessorPlugin,
  ImageLabelingOptions,
} from './types';
import { Platform } from 'react-native';

const LINKING_ERROR: string =
  `The package 'react-native-vision-camera-v3-image-labeling' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const plugin: FrameProcessorPlugin | undefined =
  VisionCameraProxy.initFrameProcessorPlugin('scanImage');
export function scanImage(frame: Frame, options: ImageLabelingOptions): object {
  'worklet';
  if (plugin == null) throw new Error(LINKING_ERROR);
  // @ts-ignore
  return options ? plugin.call(frame, options) : plugin.call(frame);
}
