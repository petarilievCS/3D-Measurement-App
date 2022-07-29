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
    
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    
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
        
        if dotNodes.count > 1 {
            for dotNode in dotNodes {
                dotNode.removeFromParentNode()
            }
            dotNodes.removeAll()
        }
        
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
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate() {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        // mathematical formula for calculating distance
        let a = start.position.x - end.position.x
        let b = start.position.y - end.position.y
        let c = start.position.z - end.position.z
        var distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        // rounding distance
        distance *= 10000
        distance = round(distance)
        distance /= 10000
        
        updateText(text: String(distance), at: end.position)
    }
    
    func updateText(text: String, at position: SCNVector3) {
        
        textNode.removeFromParentNode()
        let text = SCNText(string: text, extrusionDepth: 1.0)
        text.firstMaterial?.diffuse.contents = UIColor.blue
        
        textNode = SCNNode(geometry: text)
        textNode.position = position
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
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
