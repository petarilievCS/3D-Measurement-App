//
//  ViewController.swift
//  AR Measurment App
//
//  Created by Petar Iliev on 7/29/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: sceneView) {
            let locationsInSpace = sceneView.hitTest(location, types: .featurePoint)
            
            if let locationInSpace = locationsInSpace.first {
                addDot(at: locationInSpace)
            }
        }
    }
    
    func addDot(at location: ARHitTestResult) {
        let dotGeometry = SCNSphere(radius: 0.005)
        let dotNode = SCNNode()
        
        let dotMaterial = SCNMaterial()
        dotMaterial.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [dotMaterial]
        dotNode.position = SCNVector3(
            location.worldTransform.columns.3.x,
            location.worldTransform.columns.3.y,
            location.worldTransform.columns.3.z
        )
        dotNode.geometry = dotGeometry
        sceneView.scene.rootNode.addChildNode(dotNode)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
