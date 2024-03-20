package com.visioncamerav3imagelabeling


import android.media.Image
import com.facebook.react.bridge.WritableNativeArray
import com.facebook.react.bridge.WritableNativeMap
import com.google.android.gms.tasks.Task
import com.google.android.gms.tasks.Tasks
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.label.ImageLabel
import com.google.mlkit.vision.label.ImageLabeling
import com.google.mlkit.vision.label.defaults.ImageLabelerOptions
import com.mrousavy.camera.frameprocessor.Frame
import com.mrousavy.camera.frameprocessor.FrameProcessorPlugin
import com.mrousavy.camera.frameprocessor.VisionCameraProxy

class VisionCameraV3ImageLabelingModule (proxy : VisionCameraProxy, options: Map<String, Any>?): FrameProcessorPlugin() {
  override fun callback(frame: Frame, arguments: Map<String, Any>?): Any {
    val mediaImage: Image = frame.image

      var labeler = ImageLabeling.getClient(ImageLabelerOptions.DEFAULT_OPTIONS)
      if (arguments?.containsKey("minConfidence") == true){
          val minConfidence : Float = arguments["minConfidence"].toString().toFloat()
          if (minConfidence < 1.0 && minConfidence > 0.0 ){
              val options = ImageLabelerOptions.Builder()
                  .setConfidenceThreshold(minConfidence)
                  .build()
              labeler =ImageLabeling.getClient(options)
          }
      }
    try {
        val image = InputImage.fromMediaImage(mediaImage, 0)
        val task: Task<List<ImageLabel>> = labeler.process(image)
        val labels: List<ImageLabel> = Tasks.await(task)
        val array = WritableNativeArray()
        for (label in labels) {
          val map = WritableNativeMap()
          map.putString("label", label.text)
          map.putDouble("confidence", label.confidence.toDouble())
          map.putInt("index",label.index)
          array.pushMap(map)
        }
        return array.toArrayList()
      } catch (e: Exception) {
           throw Exception("Error processing image labeler: $e")
      }
  }
}
