//
//  CanvasViewController.swift
//  lab3
//
//  Created by Diandian Xiao on 2/17/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate{

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreateFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 160
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffset)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didPanTray(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            trayOriginalCenter = trayView.center
            
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
        } else if (sender.state == UIGestureRecognizerState.Ended)  {
            var velocity = sender.velocityInView(view)
            
            if (velocity.y > 0) {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.trayView.center = self.trayDown
                })
            }
            else {
                self.trayView.center = self.trayUp
            }
        }
    }
    
    @IBAction func didPanFace(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            var imageView = sender.view as! UIImageView
            newlyCreateFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreateFace)
            newlyCreateFace.center = imageView.center
            newlyCreateFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreateFace.center
            
            // allows for pan of newly created faces
            var panGestureReocgnizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
            var pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "onCustomPinch:")
            var rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "onCustomRotate:")
            
            pinchGestureRecognizer.delegate = self;

            newlyCreateFace.userInteractionEnabled = true
            newlyCreateFace.multipleTouchEnabled = true
            
            newlyCreateFace.addGestureRecognizer(panGestureReocgnizer)
            newlyCreateFace.addGestureRecognizer(pinchGestureRecognizer)
            newlyCreateFace.addGestureRecognizer(rotateGestureRecognizer)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.newlyCreateFace.transform = CGAffineTransformMakeScale(1.5, 1.5)
            })
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            newlyCreateFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
                
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                self.newlyCreateFace.transform = CGAffineTransformMakeScale(1, 1)
                }, completion: { (Bool) -> Void in
            })
        }
    }
    
    func onCustomPan(sender: UIPanGestureRecognizer) {
        var point = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            newlyCreateFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreateFace.center
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            newlyCreateFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == UIGestureRecognizerState.Ended {
        }
    }
    
    func onCustomPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        
        
        newlyCreateFace = sender.view as! UIImageView
        
        newlyCreateFace.transform = CGAffineTransformMakeScale(scale, scale)
        
    }
    func onCustomRotate(sender: UIRotationGestureRecognizer){
        let rotate = sender.rotation
        
        newlyCreateFace = sender.view as! UIImageView
        
        newlyCreateFace.transform = CGAffineTransformMakeRotation(rotate)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
