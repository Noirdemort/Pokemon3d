//
//  ViewController.swift
//  Poke3d
//
//  Created by Noirdemort on 08/11/18.
//  Copyright © 2018 Noirdemort. All rights reserved.
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
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.automaticallyUpdatesLighting = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        configuration.trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "PokemonCards", bundle: Bundle.main)!

        configuration.maximumNumberOfTrackedImages = 2
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        guard let imageAnchor = anchor as? ARImageAnchor else {return node}
        let plane  = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0)
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2

        
        if imageAnchor.referenceImage.name! == "eevee-card" {
            let pokeScene = SCNScene(named: "art.scnassets/eevee.scn")!
            let pokeNode = pokeScene.rootNode.childNodes.first!
            pokeNode.eulerAngles.x = -.pi/2
            pokeNode.eulerAngles.y = -.pi
            planeNode.addChildNode(pokeNode)
        }
        
        if imageAnchor.referenceImage.name! == "odish-card" {
            let pokeScene = SCNScene(named: "art.scnassets/oddish.scn")!
            let pokeNode = pokeScene.rootNode.childNodes.first!
            pokeNode.eulerAngles.x = -.pi/2
            planeNode.addChildNode(pokeNode)
        }
        node.addChildNode(planeNode)
        return node
    }
}
