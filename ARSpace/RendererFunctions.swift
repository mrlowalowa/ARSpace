//
//  RendererFunctions.swift
//  ARSpace
//
//  Created by Matthias Vietz on 05.11.17.
//  Copyright © 2017 Florian Gramß. All rights reserved.
//

import SceneKit
import ARKit
func renderer_Add(node: SCNNode, anchor: ARAnchor, sceneView : ARSCNView, planeNode : inout SCNNode, viewcontroller : ViewController) -> Bool {
        // Place content only for anchors found by plane detection.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return false}
        //Plane Found
        //Remove old Plane
        planeNode.removeFromParentNode()
    

        // Create a SceneKit plane to visualize the plane anchor using its position and extent.
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        planeNode = SCNNode(geometry: plane)
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        /*
         `SCNPlane` is vertically oriented in its local coordinate space, so
         rotate the plane to match the horizontal orientation of `ARPlaneAnchor`.
         */
        planeNode.eulerAngles.x = -.pi / 2
        
        // Make the plane visualization semitransparent to clearly show real-world placement.
        planeNode.opacity = 0.5
        
        //TEST
//        var cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
//        var testnode = SCNNode(geometry: cube)
//        var x = planeAnchor.center.x
//        if (abs(x - planeAnchor.extent.x/2) < abs( x + planeAnchor.extent.x/2)){
//            x =  x - planeAnchor.extent.x/2
//        }
//        else{
//            x =  x + planeAnchor.extent.x/2
//        }
//        testnode.simdPosition = float3(x, 0, planeAnchor.center.z)
        
        /*
         Add the plane visualization to the ARKit-managed node so that it tracks
         changes in the plane anchor as plane estimation continues.
         */
        node.addChildNode(planeNode)
//        node.addChildNode(testnode)
        
        //Activate Button
        viewcontroller.planeFound()
    
    
    return true
}
func renderer_Update(planeNode: inout SCNNode, anchor: ARAnchor) -> Bool {
    
        // Update content only for plane anchors and nodes matching the setup created in `renderer(_:didAdd:for:)`.
        
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
//            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { NSLog("exited from Update"); return false}


        // Plane estimation may shift the center of a plane relative to its anchor's transform.
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)

        /*
         Plane estimation may extend the size of the plane, or combine previously detected
         planes into a larger one. In the latter case, `ARSCNView` automatically deletes the
         corresponding node for one plane, then calls this method to update the size of
         the remaining plane.
         */
        plane.width = CGFloat(planeAnchor.extent.x)
        plane.height = CGFloat(planeAnchor.extent.z)
    
    return true
}
