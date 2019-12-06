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
    var textRecognizer:VisionTextRecognizer! // Google API text recognizer
    var elementText: String = "" // keeps track of what each API is outputing either text or tag
    let captureSession = AVCaptureSession()
    var addedIngredients : [String] = [] //ingredients added when user touches add, to be passed back to view controller user came from
    var seguedFrom:SeguedFrom? // keeps track of which view controller to segue back to
    private lazy var sessionQueue = DispatchQueue(label: "videoQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vision = Vision.vision()
        textRecognizer = vision.onDeviceTextRecognizer()
        // we set up our capture session here
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else{return}
        captureSession.addInput(input)
        captureSession.startRunning()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        let dataOutput = AVCaptureVideoDataOutput()
        
        // google vision API requires capture format of kCVPixelFormatType_32BGRA
        dataOutput.videoSettings = [
          (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA,
        ]
        dataOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        captureSession.addOutput(dataOutput)
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        addedIngredients.append(elementText)
    }
    
    // we perform segues to the view comtroller we came from, we keep track of the location of segue by setting seguedFrom from prior view controller
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
            vc.initialIngredients = addedIngredients
        }
        else if let vc = segue.destination as? PantryIngredientsAdd{
            vc.ingredientsFromCamera = addedIngredients
        }
    }
    
    //used to specify the orientation of the image data contained in our CMSampleBuffer
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
    
    @IBOutlet weak var visionOutputTag: UILabel! // displays what elementtext contains
    
    // new video frames are written and we can use the sample buffer to process these frames
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let visionImage = VisionImage(buffer: sampleBuffer)
        let cameraPosition = AVCaptureDevice.Position.back
        let metadata = VisionImageMetadata()
        metadata.orientation = imageOrientation(
          deviceOrientation: UIDevice.current.orientation,
          cameraPosition: cameraPosition
        )
        visionImage.metadata = metadata
        
        // We process the image from the live buffer feed for text recognition first
        textRecognizer.process(visionImage){ result, error in
            guard error == nil, let result = result else {
                // incase there was no text detected we run the coreml API for the best possible label detection here
                guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
                guard let model = try? VNCoreMLModel(for: Resnet50().model) else {return}
                let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
                    guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
                    guard let firstObservation = results.first else{return}
                    self.visionOutputTag.text = firstObservation.identifier
                    self.elementText = firstObservation.identifier
                }
                try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
                return
            }
            
            // parse through all the visible text, we want to place the last element on the camera screen to be our elementtext
            for block in result.blocks {
                for line in block.lines {
                    for element in line.elements {
                        self.elementText = element.text
                    }
                }
            }
            self.visionOutputTag.textColor = .red
            self.visionOutputTag.text = self.elementText
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
