//
//  CameraViewController.swift
//  Recipe App
//
//  Created by Zohaib Ahmad on 11/24/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreVideo
import FirebaseMLVision


class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var textRecognizer:VisionTextRecognizer!
    var labler:VisionImageLabeler!
    var lastFrame:CMSampleBuffer?
    override func viewDidLoad() {
        super.viewDidLoad()
        let vision = Vision.vision()
        labler = vision.onDeviceImageLabeler()
        textRecognizer = vision.onDeviceTextRecognizer()
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else{return}
        
        captureSession.addInput(input)
        
        captureSession.startRunning()
//        let cameraPosition = AVCaptureDevice.Position.back  // Set to the capture device you used.
//        let metadata = VisionImageMetadata()
//        metadata.orientation = imageOrientation(
//            deviceOrientation: UIDevice.current.orientation,
//            cameraPosition: cameraPosition
//        )
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [
          (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA,
        ]
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        // Do any additional setup after loading the view.
    }
    
    func imageOrientation(
        deviceOrientation: UIDeviceOrientation,
        cameraPosition: AVCaptureDevice.Position
        ) -> VisionDetectorImageOrientation {
        switch deviceOrientation {
        case .portrait:
//            print("portrait")
            return cameraPosition == .front ? .leftTop : .rightTop
        case .landscapeLeft:
//            print("landscapeleft")
            return cameraPosition == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
//            print("portraitupsodedown")
            return cameraPosition == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
//            print("landscaperight")
            return cameraPosition == .front ? .topRight : .bottomRight
        case .faceDown, .faceUp, .unknown:
//            print("mehhhh")
            return .leftTop
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("yeeeeee")
//        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//              print("Failed to get image buffer from sample buffer.")
//              return
//        }
//        lastFrame = sampleBuffer
        let visionImage = VisionImage(buffer: sampleBuffer)
        let cameraPosition = AVCaptureDevice.Position.back
        let metadata = VisionImageMetadata()
        metadata.orientation = imageOrientation(
          deviceOrientation: UIDevice.current.orientation,
          cameraPosition: cameraPosition
        )

//        let image = VisionImage(buffer: sampleBuffer)
        visionImage.metadata = metadata
//        print(image.metadata)
        labler.process(visionImage){labels, error in
            guard error == nil, let labels = labels else {
                print("label detection error")
                return
                
            }
//            print("wtwtwtwtwwtwtwtwtwt")
//            print(labels)
//            print(labels)
            for l in labels{
                print("laaaaabbbbbbbeeeeeeeellssss")
                print(l.text)
//                print(l.entityID)
                print(l.confidence)
                print("labellllllllllssssssssssssssseeeeeeennnnnddddd\n")
            }
        }
        
        textRecognizer.process(visionImage){ result, error in
            guard error == nil, let result = result else {
                print(error)
//                print("naaahhhhhhh")
                return
            }
//            print("ayyyyyeeeeeeee")
            
            
            let resultText = result.text
            for block in result.blocks {
                let blockText = block.text
                let blockConfidence = block.confidence
                let blockLanguages = block.recognizedLanguages
                let blockCornerPoints = block.cornerPoints
                let blockFrame = block.frame
                for line in block.lines {
                    let lineText = line.text
                    let lineConfidence = line.confidence
                    let lineLanguages = line.recognizedLanguages
                    let lineCornerPoints = line.cornerPoints
                    let lineFrame = line.frame
                    for element in line.elements {
                        let elementText = element.text
                        let elementConfidence = element.confidence
                        let elementLanguages = element.recognizedLanguages
                        let elementCornerPoints = element.cornerPoints
                        let elementFrame = element.frame
                        print("texxxxxxxxxxtttttttttttttttt")
                        print(elementText)
                        print(elementConfidence)
                        print("teexxxxxxxxxxxxtttttttttttteeeeeeennnnnnnddddddd\n")
//                        print(elementLanguages)
//                        print(elementCornerPoints)
//                        print(elementFrame)
                    }
                }
            }
        }
        
//          detectImageLabelsAutoMLOndevice(in: visionImage, width: imageWidth, height: imageHeight)
//
//          recognizeTextOnDevice(in: visionImage, width: imageWidth, height: imageHeight)
        
        
      
//        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
//        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {return}
//        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
////            print(finishedReq.results)
//            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
//            guard let firstObservation = results.first else{return}
//            print(firstObservation.identifier, firstObservation.confidence)
//        }
//        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
