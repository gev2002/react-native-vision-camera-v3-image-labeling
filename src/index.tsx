import React from 'react';
import {
  VisionCameraProxy,
  Camera as VisionCamera,
  useFrameProcessor,
} from 'react-native-vision-camera';
import { useRunInJS } from 'react-native-worklets-core';
import type {
  ImageLabelingOptions,
  Frame,
  FrameProcessor,
  CameraTypes,
  FrameProcessorPlugin,
} from './types';
import { Platform } from 'react-native';

const LINKING_ERROR: string =
  `The package 'react-native-vision-camera-v3-image-labeling' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const plugin: FrameProcessorPlugin | undefined =
  VisionCameraProxy.initFrameProcessorPlugin('scanImage');

function scanImage(frame: Frame, options: ImageLabelingOptions): object {
  'worklet';
  if (plugin == null) throw new Error(LINKING_ERROR);
  // @ts-ignore
  return options ? plugin.call(frame, options) : plugin.call(frame);
}

export const Camera = (props: CameraTypes) => {
  const { callback, options, device } = props;
  // @ts-ignore
  const useWorklets = useRunInJS((data: object): void => {
    callback(data);
  }, []);
  const frameProcessor: FrameProcessor = useFrameProcessor(
    (frame: Frame): void => {
      'worklet';
      // @ts-ignore
      const data: object = scanImage(frame, options);
      // @ts-ignore
      useWorklets(data);
    },
    []
  );
  return (
    !!device && <VisionCamera frameProcessor={frameProcessor} {...props} />
  );
};
