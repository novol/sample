//
//  DescaleImageView.swift
//  s_KaimonoList_v01
//
//  Created by i.novol on 2015/10/25.
//  Copyright © 2015年 i.novol. All rights reserved.
//

import UIKit

class DescaleImageView: UIImageView {

    //* Gesture Enabled Whether or not */
    var gestureEnabled = true
    
    // private variables
    private var beforePoint = CGPointMake(0.0, 0.0)
    private var currentScale:CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.contentMode = UIViewContentMode.ScaleAspectFit
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        self.userInteractionEnabled = true
//        
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: "handleGesture:")
//        self.addGestureRecognizer(pinchGesture)
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: "handleGesture:")
//        self.addGestureRecognizer(tapGesture)
//        
//        let longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleGesture:")
//        self.addGestureRecognizer(longPressGesture)
//        
//        let panGesture = UIPanGestureRecognizer(target: self, action: "handleGesture:")
//        self.addGestureRecognizer(panGesture)
//    }
//    
//    func handleGesture(gesture: UIGestureRecognizer){
//        if let tapGesture = gesture as? UITapGestureRecognizer{
//            tap(tapGesture)
//        }else if let pinchGesture = gesture as? UIPinchGestureRecognizer{
//            pinch(pinchGesture)
//        }else if let panGesture = gesture as? UIPanGestureRecognizer{
//            pan(panGesture)
//        }
//    }
//    
//    private func pan(gesture:UIPanGestureRecognizer){
//        if self.gestureEnabled{
//            
//            if let gestureView = gesture.view{
//                
//                var translation = gesture.translationInView(gestureView)
//                
//                if abs(self.beforePoint.x) > 0.0 || abs(self.beforePoint.y) > 0.0{
//                    translation = CGPointMake(self.beforePoint.x + translation.x, self.beforePoint.y + translation.y)
//                }
//                
//                switch gesture.state{
//                case .Changed:
//                    let scaleTransform = CGAffineTransformMakeScale(self.currentScale, self.currentScale)
//                    let translationTransform = CGAffineTransformMakeTranslation(translation.x, translation.y)
//                    self.transform = CGAffineTransformConcat(scaleTransform, translationTransform)
//                case .Ended , .Cancelled:
//                    self.beforePoint = translation
//                default:
//                    NSLog("no action")
//                }
//            }
//        }
//    }
//    
//    private func tap(gesture:UITapGestureRecognizer){
//        if self.gestureEnabled{
//            UIView.animateWithDuration(0.2, animations: { () -> Void in
//                self.beforePoint = CGPointMake(0.0, 0.0)
//                self.currentScale = 1.0
//                self.transform = CGAffineTransformIdentity
//            })
//        }
//    }
//    
//    private func pinch(gesture:UIPinchGestureRecognizer){
//        
//        if self.gestureEnabled{
//            
//            var scale = gesture.scale
//            if self.currentScale > 1.0{
//                scale = self.currentScale + (scale - 1.0)
//            }
//            switch gesture.state{
//            case .Changed:
//                let scaleTransform = CGAffineTransformMakeScale(scale, scale)
//                let transitionTransform = CGAffineTransformMakeTranslation(self.beforePoint.x, self.beforePoint.y)
//                self.transform = CGAffineTransformConcat(scaleTransform, transitionTransform)
//            case .Ended , .Cancelled:
//                if scale <= 1.0{
//                    self.currentScale = 1.0
//                    self.transform = CGAffineTransformIdentity
//                }else{
//                    self.currentScale = scale
//                }
//            default:
//                NSLog("not action")
//            }
//        }
//    }
}
