
The frame processor plugin to image labeling using Google ML Kit library for react-native-vision-camera with high performance.


# 🚨 Required Modules
react-native-vision-camera => 4.0.0 <br/>
react-native-worklets-core = 1.1.1

## 💻 Installation

```sh
npm install react-native-vision-camera-v3-image-labeling
yarn add react-native-vision-camera-v3-image-labeling
```
## 👷Features
    Easy To Use.
    Works Just Writing few lines of Code.
    Works With React Native Vision Camera.
    Works for Both Cameras.
    Works Fast.
    Works With Android 🤖 and IOS.📱
    Writen With Kotlin and Objective-C.

## 💡 Usage

```js
import React, { useState } from 'react'
import { useCameraDevice } from 'react-native-vision-camera'
import { Camera } from 'react-native-vision-camera-v3-image-labeling';

function App (){
  const [data,setData] = useState(null)
  const device = useCameraDevice('back');
  console.log(data)
  return(
    <>
      {!!device && (
        <Camera
          style={StyleSheet.absoluteFill}
          device={device}
          isActive
          // optional
          options={{
            minConfidence: 0.1
          }}
          callback={(d) => setData(d)}
        />
      )}
    </>
  )
}

```
### Also You Can Use Like This

```js
import React from 'react';
import { StyleSheet } from "react-native";
import {
  Camera,
  useCameraDevice,
  useFrameProcessor,
} from "react-native-vision-camera";
import { useImageLabeler } from "react-native-vision-camera-v3-image-labeling";

function App() {
  const device = useCameraDevice('back');
  const options = {minConfidence : 0.1}
  const {scanImage} = useImageLabeler(options)
  const frameProcessor = useFrameProcessor((frame) => {
    'worklet'
    const data = scanImage(frame)
	console.log(data, 'data')
  }, [])
  return (
      <>
      {!!device && (
        <Camera
          style={StyleSheet.absoluteFill}
          device={device}
          isActive
          frameProcessor={frameProcessor}
        />
      )}
      </>
  );
}
export default App;
```


---

## ⚙️ Options

| Name |  Type    |  Values   | Default |
| :---:   | :---: |:---------:|  :---: |
| minConfidence | Number   | 0.1 - 1.0 | 0.1 |
















