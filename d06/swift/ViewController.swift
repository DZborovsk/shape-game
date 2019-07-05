//
//  ViewController.swift
//  d06
//
//  Created by Danyil ZBOROVKYI on 7/2/19.
//  Copyright © 2019 Danyil ZBOROVKYI. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    var dynamicAnimator = UIDynamicAnimator()
    var gravityBehaviour = UIGravityBehavior()
    var collisionBehaviour = UICollisionBehavior()
    var itemBehaviour = UIDynamicItemBehavior()
    let motionManager = CMMotionManager()
    

    
    @IBAction func clearButton(_ sender: UIButton) {
        for view in view.subviews {
            if view.backgroundColor != .none {
                gravityBehaviour.removeItem(view)
                collisionBehaviour.removeItem(view)
                itemBehaviour.removeItem(view)
                view.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        dynamicAnimator.addBehavior(gravityBehaviour)
        collisionBehaviour.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehaviour)
        dynamicAnimator.addBehavior(itemBehaviour)
        itemBehaviour.elasticity = 0.8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.2
            let queue = OperationQueue.main
            motionManager.startAccelerometerUpdates(to: queue, withHandler: accHandler)
        }
    }
    
    func accHandler(data: CMAccelerometerData?, error: Error?) {
        if let myData = data {
            let x = CGFloat(myData.acceleration.x);
            let y = CGFloat(myData.acceleration.y);
            let v = CGVector(dx: x, dy: -y);
            gravityBehaviour.gravityDirection = v;
            gravityBehaviour.magnitude = 10
        }
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        print("tap en position \(sender.location(in: view))")
        let centerPoint = sender.location(in: self.view)
        let shape = Shape(centerPoint: centerPoint, maxWidth: self.view.bounds.width, maxHeight: self.view.bounds.height)
        
        view.addSubview(shape)
        gravityBehaviour.addItem(shape)
        collisionBehaviour.addItem(shape)
        itemBehaviour.addItem(shape)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesture:)))
        shape.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(gesture:)))
        shape.addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotationGesture(gesture:)))
        shape.addGestureRecognizer(rotationGesture)
        
    }
    
    @objc func panGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("Began")
            gravityBehaviour.removeItem(gesture.view!)
        case .changed:
            print("Changed to \(gesture.location(in: view))")
            gesture.view?.center = gesture.location(in: gesture.view?.superview)
            dynamicAnimator.updateItem(usingCurrentState: gesture.view!)
        case .ended:
            print("End")
            gravityBehaviour.addItem(gesture.view!)
        case .failed, .cancelled:
            print("error")
            break
        case .possible:
            print("Possible")
            break
        @unknown default:
            print("error")
            break
        }
    }
    
    @objc func pinchGesture(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("Began")
            gravityBehaviour.removeItem(gesture.view!)
            collisionBehaviour.removeItem(gesture.view!)
            itemBehaviour.removeItem(gesture.view!)
        case .changed:
            print("Changed to \(gesture.location(in: view))")
            gesture.view?.layer.bounds.size.height *= gesture.scale
            gesture.view?.layer.bounds.size.width *= gesture.scale
            
            if let shape = gesture.view! as? Shape {
                if (shape.circle) {
                    gesture.view!.layer.cornerRadius *= gesture.scale
                }
            }
            gesture.scale = 1
        case .ended:
            print("End")
            gravityBehaviour.addItem(gesture.view!)
            collisionBehaviour.addItem(gesture.view!)
            itemBehaviour.addItem(gesture.view!)
        case .failed, .cancelled:
            print("error")
            break
        case .possible:
            print("Possible")
            break
        @unknown default:
            print("error")
            break
        }
    }
    
    @objc func rotationGesture(gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("rotationGesture began")
            collisionBehaviour.removeItem(gesture.view!)
            itemBehaviour.removeItem(gesture.view!)
            gravityBehaviour.removeItem(gesture.view!)
        case .ended:
            print("rotationGesture ended")
            gravityBehaviour.addItem(gesture.view!)
            collisionBehaviour.addItem(gesture.view!)
            itemBehaviour.addItem(gesture.view!)
        case .changed:
            print("rotationGesture changed")
            
            gesture.view?.transform = (gesture.view?.transform.rotated(by: gesture.rotation))!
            
            dynamicAnimator.updateItem(usingCurrentState: gesture.view!)
            gesture.rotation = 0
        case .failed, .cancelled:
            print("error")
            break
        case.possible:
            print("possible")
            break
        @unknown default:
            print("error")
            break
        }
    }

}
