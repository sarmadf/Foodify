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
import Vision


enum SeguedFrom{
    case ingredientsAdd
    case pantryAdd
    case pantry
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var textRecognizer:VisionTextRecognizer!
    var labler:VisionImageLabeler!
    var lastFrame:CMSampleBuffer?
    var elementText: String = ""
    let captureSession = AVCaptureSession()
    var addedIngredients : [String] = []
    var seguedFrom:SeguedFrom?
    private lazy var sessionQueue = DispatchQueue(label: "videoQueue")
    var shouldQuit:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vision = Vision.vision()
        labler = vision.onDeviceImageLabeler()
        textRecognizer = vision.onDeviceTextRecognizer()
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else{return}
        captureSession.addInput(input)
        captureSession.startRunning()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [
          (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA,
        ]
        dataOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        captureSession.addOutput(dataOutput)
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        addedIngredients.append(elementText)
    }
    
    
    @IBAction func quitButtonPressed(_ sender: Any) {
        if let seguedFrom = self.seguedFrom{
            switch seguedFrom{
            case .ingredientsAdd:
                performSegue(withIdentifier: "cameraToIngredientsAdd", sender: self)
                break
            case .pantryAdd:
                performSegue(withIdentifier: "cameraToPantryAddIngredients", sender: self)
                break
            default:
                performSegue(withIdentifier: "cameraToPantryAddIngredients", sender: self)
                break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionQueue.async {
          self.captureSession.stopRunning()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue is to the RecipeView, populate the RecipeView's id and image fields using the RecipeSearchResult at the index of the table cell that was clicked.
        self.captureSession.stopRunning()
        if let vc = segue.destination as? IngredientsAdd
        {
            print("Destination is ingredients add")
            vc.initialIngredients = addedIngredients
        }
        else if let vc = segue.destination as? PantryIngredientsAdd{
            print("Destination is pantry ingredients add")
            vc.ingredientsFromCamera = addedIngredients
        }
    }
    
    func imageOrientation(
        deviceOrientation: UIDeviceOrientation,
        cameraPosition: AVCaptureDevice.Position
        ) -> VisionDetectorImageOrientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftTop : .rightTop
        case .landscapeLeft:
            return cameraPosition == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
            return cameraPosition == .front ? .topRight : .bottomRight
        case .faceDown, .faceUp, .unknown:
            return .leftTop
        }
    }
    @IBOutlet weak var visionOutputTag: UILabel!
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let visionImage = VisionImage(buffer: sampleBuffer)
        let cameraPosition = AVCaptureDevice.Position.back
        let metadata = VisionImageMetadata()
        metadata.orientation = imageOrientation(
          deviceOrientation: UIDevice.current.orientation,
          cameraPosition: cameraPosition
        )
        visionImage.metadata = metadata
            
        
//            labler.process(visionImage){labels, error in
//                guard error == nil, let labels = labels else {
//                    print("label detection error")
//                    return
//
//                }
//    ////            print("wtwtwtwtwwtwtwtwtwt")
//    ////            print(labels)
//    ////            print(labels)
//    //            print("begin labeling")
//                for l in labels{
//    ////                print("laaaaabbbbbbbeeeeeeeellssss")
//                    self.visionOutputTag.text = l.text
//                    print(l.text)
//    ////                print(l.entityID)
//    //                print(l.confidence)
//    ////                print("labellllllllllssssssssssssssseeeeeeennnnnddddd\n")
//                }
//    //            print("end labeling")
//            }
//        }
        textRecognizer.process(visionImage){ result, error in
            guard error == nil, let result = result else {
//                self.labler.process(visionImage){labels, error in
//                            guard error == nil, let labels = labels else {
//                                print("label detection error")
//                                return
//
//                            }
//                            for l in labels{
//                                self.visionOutputTag.text = l.text
//                                print(l.text)
//                ////                print(l.entityID)
//                //                print(l.confidence)
//                            }
//                        }
                guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
                guard let model = try? VNCoreMLModel(for: Resnet50().model) else {return}
                let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
        //            print(finishedReq.results)
                    guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
                    guard let firstObservation = results.first else{return}
                    self.visionOutputTag.text = firstObservation.identifier
                    self.elementText = firstObservation.identifier
                    print(firstObservation.identifier, firstObservation.confidence)
                }
                try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
                return
            }
            
            let resultText = result.text
            var count = 0
            for block in result.blocks {
                for line in block.lines {
                    let lineText = line.text
                    print(lineText)
                    for element in line.elements {
                        self.elementText = element.text
                        print(self.elementText)
                    }
                }
            }
            self.visionOutputTag.textColor = .red
            self.visionOutputTag.text = self.elementText
//            self.captureSession.stopRunning()
            
            
        }
        
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
