//
//  ViewController.swift
//  MyRandomPalette
//
//  Created by Ong Xin Ying on 17/2/18.
//  Copyright © 2018 Ong Xin Ying. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textLabelForTitle: UILabel!
    
    @IBOutlet weak var textLabelForAPI: UILabel!
    
    @IBOutlet weak var textLabelForHex: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    
    @IBAction func refreshClick(_ sender: Any) {
        parseJSON ()
    }
    
    @IBAction func shareClick(_ sender: Any) {
        imageForSnapShot = self.view.snapshot!
        let activity = UIActivityViewController(activityItems: [imageForSnapShot], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = self.view
        
        self.present(activity, animated: true, completion: nil)
    }
    
    var imageForSnapShot = UIImage()
    var colorArray = [String] ()
    var paletteTitle: String = ""
    let view1 = UIView()
    let view2 = UIView()
    let view3 = UIView()
    let view4 = UIView()
    
    var refreshPage: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        parseJSON()
        let totalWidth = view.frame.width
        view1.frame = CGRect(x: 0, y: 0, width: totalWidth, height: 100)
        view2.frame = CGRect(x: 0, y: 100, width: totalWidth, height: 55)
        view3.frame = CGRect(x: 0, y: 155, width: totalWidth, height: 75)
        view4.frame = CGRect(x: 0, y: 230, width: totalWidth, height: 30)
        view.addSubview(view1)
        view.addSubview(view2)
        view.addSubview(view3)
        view.addSubview(view4)
        shareButton.layer.cornerRadius = 7
        refreshButton.layer.cornerRadius = 7
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseJSON () {

        let url = URL(string: "http://www.colourlovers.com/api/palettes/random?format=json")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error ) in
            guard let jsonObject : Any = (try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) else {
                print("Not containing JSON")
                return
            }
            if let colourJson = jsonObject as? NSArray{
                if let colourPalette = colourJson[0] as? NSDictionary{
                    if let colour = colourPalette["colors"] as? [String] {
                        self.colorArray = colour
                        DispatchQueue.main.async { // load UI in main thread
                            self.view1.backgroundColor = UIColor(hex: self.colorArray[0])
                            self.textLabelForHex.text = self.colorArray[0]
                            let arrayCount = self.colorArray.count
                            
                            switch (arrayCount)
                            {
                            case 1:
                                self.view1.backgroundColor = UIColor(hex: self.colorArray[0])
                                self.view2.backgroundColor = .white
                                self.view3.backgroundColor = .white
                                self.view4.backgroundColor = .white
                                self.view.backgroundColor = .white
                                self.textLabelForHex.text = self.colorArray[0];
                                
                            case 2:
                                self.view1.backgroundColor = UIColor(hex: self.colorArray[0])
                                self.view2.backgroundColor = UIColor(hex: self.colorArray[1])
                                self.view3.backgroundColor = .white
                                self.view4.backgroundColor = .white
                                self.view.backgroundColor = .white
                                self.textLabelForHex.text = self.colorArray[0] + "-" + self.colorArray[1];
                                
                            case 3:
                                self.view1.backgroundColor = UIColor(hex: self.colorArray[0])
                                self.view2.backgroundColor = UIColor(hex: self.colorArray[1])
                                self.view3.backgroundColor = UIColor(hex: self.colorArray[2])
                                self.view4.backgroundColor = .white
                                self.view.backgroundColor = .white
                                self.textLabelForHex.text = self.colorArray[0] + "-" + self.colorArray[1] + "-"
                                    + self.colorArray[2];
                                
                            case 4:
                                self.view1.backgroundColor = UIColor(hex: self.colorArray[0])
                                self.view2.backgroundColor = UIColor(hex: self.colorArray[1])
                                self.view3.backgroundColor = UIColor(hex: self.colorArray[2])
                                self.view4.backgroundColor = UIColor(hex: self.colorArray[3])
                                self.view.backgroundColor = .white
                                self.textLabelForHex.text = self.colorArray[0] + "-" + self.colorArray[1] + "-"
                                    + self.colorArray[2] + "-" + self.colorArray[3];
                                
                            case 5:
                                self.view1.backgroundColor = UIColor(hex: self.colorArray[0])
                                self.view2.backgroundColor = UIColor(hex: self.colorArray[1])
                                self.view3.backgroundColor = UIColor(hex: self.colorArray[2])
                                self.view4.backgroundColor = UIColor(hex: self.colorArray[3])
                                self.view.backgroundColor = UIColor(hex: self.colorArray[4])
                                self.textLabelForHex.text = self.colorArray[0] + "-" + self.colorArray[1] + "-"
                                    + self.colorArray[2] + "-" + self.colorArray[3] + "-" + self.colorArray[4];
                                
                            default:
                                self.parseJSON()
                            }
                        }
                    }
                    if let title = colourPalette["title"] as? String{
                        self.paletteTitle = title
                        DispatchQueue.main.async { //load UI in main thread
                            self.textLabelForTitle.text = "Palette Title: " + title
                            self.textLabelForAPI.text = "Powered by COLOURlovers API"
                            self.shareButton.setTitle("Share", for: UIControlState.normal)
                            self.refreshButton.setTitle("Get Random!", for: UIControlState.normal)
                            self.textLabelForTitle.backgroundColor = .white
                            self.textLabelForAPI.backgroundColor = .white
                            self.textLabelForHex.backgroundColor = .white
                            self.refreshButton.backgroundColor = .white
                            self.shareButton.backgroundColor = .white
                        }
                    }
                }
            }
        }
        task.resume()

    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension UIView {
    
    var snapshot: UIImage?  {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0);
        if let _ = UIGraphicsGetCurrentContext() {
            drawHierarchy(in: bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
}

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}



