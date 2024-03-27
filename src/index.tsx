import React, { forwardRef,type ForwardedRef }  from 'react';
import {
  Camera as VisionCamera,
  useFrameProcessor,
} from 'react-native-vision-camera';
import { useRunInJS } from 'react-native-worklets-core';
import { scanImage } from './scanImage';
import type { Frame, FrameProcessor, CameraTypes } from './types';

export const Camera = forwardRef(function Camera(props: CameraTypes,ref:ForwardedRef<any>) {
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
});
