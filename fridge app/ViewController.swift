//
//  ViewController.swift
//  fridge app
//
//  Created by Hussien Hussien on 2017-01-07.
//  Copyright © 2017 Hussien Hussien. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var captureDevice: AVCaptureDevice!
    var captureDeviceInput: AVCaptureDeviceInput!
    var captureDeviceOutput: AVCaptureMetadataOutput!
    var capturePreviewLayer: AVCaptureVideoPreviewLayer!
    var alertController: UIAlertController!
    
    func initializeScanner() {
        captureSession = AVCaptureSession()
        
        do {
            // get the default device and use auto settings
            captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            try captureDevice.lockForConfiguration()
            captureDevice.exposureMode = AVCaptureExposureMode.continuousAutoExposure
            captureDevice.whiteBalanceMode = AVCaptureWhiteBalanceMode.continuousAutoWhiteBalance
            captureDevice.focusMode = AVCaptureFocusMode.continuousAutoFocus
            if captureDevice.hasTorch {
                captureDevice.torchMode = AVCaptureTorchMode.auto
            }
            captureDevice.unlockForConfiguration()
            
            // add the input/output devices
            captureSession.beginConfiguration()
            captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(captureDeviceInput) {
                captureSession.addInput(captureDeviceInput)
            }
            
            // AVCaptureMetadataOutput is how we can determine
            captureDeviceOutput = AVCaptureMetadataOutput()
            captureDeviceOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            if captureSession.canAddOutput(captureDeviceOutput) {
                captureSession.addOutput(captureDeviceOutput)
                captureDeviceOutput.metadataObjectTypes = captureDeviceOutput.availableMetadataObjectTypes
            }
            captureSession.commitConfiguration()
        }
        catch {
            displayAlert("Error", message: "Unable to set up the capture device.")
        }
        
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer.frame = self.view.layer.bounds
        capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(capturePreviewLayer)
    }
    
    func startScanner() {
        if captureSession != nil {
            captureSession.startRunning()
        }
    }
    
    func stopScanner() {
        if captureSession != nil {
            captureSession.stopRunning()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializeScanner()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startScanner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScanner()
    }
    
    func displayAlert(_ title: String, message: String) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
            self.alertController = nil
        })
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func lookUpBarcode(bar: String)-> String{
        let baseURL = "https://api.upcitemdb.com/prod/trial/lookup?upc="+bar
        
        
        
        
        let url = URL(string: baseURL)
        
        //let request = NSURLRequest(url: url as URL)
        
        
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                print("Else statement")
                if let content = data
                {
                    print("else if")
                    do
                    {
                        //Array
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let title = myJson["items"] as? NSDictionary
                        {
                            print(title)
                            //if let currency = rates["NOK"]
                            //{
                            //    print (currency)
                            //}
                        }
                    }
                    catch
                    {
                        
                    }
                }
            }
        }
        print("Yolo")
        task.resume()
        
        return title!
    }

        /*
        let url = NSURL(string: baseURL)
        let request = URLRequest(URL: url! as URL)
        let session = URLSession(configuration:NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request){ (data, response, error)-> Void in
            if error == nil{
     
                let swiftyJSON = JSON(data:data!)
                let theTitle = swiftyJSON["items"][0]["title"].stringValue
                println(theTitle)
                
                
            }else{
                println("There was an error")
            }
        
        
        }
 
        
        
        return (theTitle)
    }
 */
    
    func lookUp(bar: String)-> String{
        let new_string = "Hello, " + bar
        
        return (new_string)
    }
    /* AVCaptureMetadataOutputObjectsDelegate */
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if alertController != nil {
            return
        }
        
        if metadataObjects != nil && metadataObjects.count > 0 {
            if let machineReadableCode = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                // get the barcode string
                let type = machineReadableCode.type
                let barcode = machineReadableCode.stringValue
                
                // display the barcode in an alert
                let title = "Barcode"
                let message = "Type: \(type)\nBarcode: \(barcode)"
                displayAlert(title, message: message)
            }
            
            
        }
      
        
    }
    
}



