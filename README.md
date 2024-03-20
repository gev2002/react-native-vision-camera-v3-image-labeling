
The frame processor plugin to image labeling using Google ML Kit library for react-native-vision-camera with high performance.


# 🚨 Required Modules
react-native-vision-camera => 3.9.0
react-native-worklets-core = 0.4.0

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
import { Camera } from 'react-native-vision-camera-v3-image-labeling';

const [labels,setLabels] = useState(null)

console.log(labels)

<Camera
// optional
  options={{
  minConfidence: 0.1
    }}
  style={StyleSheet.absoluteFill}
  device={device}
  callback={(data) => setLabels(data)}
  {...props}
/>
```


---

## ⚙️ Options

| Name |  Type    |  Values   | Default |
| :---:   | :---: |:---------:|  :---: |
| minConfidence | Number   | 0.1 - 1.0 | 0.1 |
















