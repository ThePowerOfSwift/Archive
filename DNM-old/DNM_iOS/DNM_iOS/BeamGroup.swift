//
//  BeamGroup.swift
//  DNM_iOS
//
//  Created by James Bean on 8/19/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

public class BeamGroup: ViewNode, BuildPattern {
    
    public var viewModel: BeamGroupViewModel!
    
    // experimental - deprecate
    public var renderInterval: DurationInterval?
    
    public var hasBeenBuilt: Bool = false
    
    public var id: String? // FOR TESTING ONLY! will be on Component-level only later

    public var bgStratum: BeamGroupStratum?
    public var beamGroupEvents: [BeamGroupEvent] { get { return getBGEvents() } }
    public var bgContainers: [BeamGroupContainer] = []
    
    public var tbGroupAtDepth: [Int : TBGroup] = [:]
    public var beamsLayerGroupAtDepth: [Int : BeamsLayerGroup] = [:]
    
    public var beamsLayerGroup: BeamsLayerGroup?
    public var tupletBracketGroup = TBGroup()
    
    public var augmentationDots: [AugmentationDot] = []
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(viewModel: BeamGroupViewModel) {
        super.init()
        self.viewModel = viewModel
        self.left = viewModel.origin.x
        stackDirectionVertical = viewModel.stemDirection == .Down ? .Top : .Bottom
    }

    
    public func renderInDurationInterval(durationInterval: DurationInterval) throws {
        enum Error: ErrorType { case InvalidDurationInterval, Error }
        let allowableRelationships: [IntervalRelationship] = [
            .During, .Starts, .Finishes, .Equal, .Overlaps
        ] // not [.Meets, .TakesPlaceBefore, .TakesPlaceAfter]

        let relationship = durationInterval.relationshipToDurationInterval(
            viewModel.model.durationInterval
        )
        
        if allowableRelationships.contains(relationship) {
            renderInterval = durationInterval
        } else {
            throw Error.InvalidDurationInterval
        }
    }
    
    public func build() {
        var x: CGFloat = 0
        descendToBuildWithDurationNode(viewModel.model, context: self, x: &x)
        commitTupletBracketGroups() // add in build()
        addNode(beamsLayerGroup!)
        layout()
        hasBeenBuilt = true
    }
    
    private func buildWithDurationNode(durationNode: DurationNode) {
        var x: CGFloat = 0
        descendToBuildWithDurationNode(durationNode, context: self, x: &x)
    }
    
    private func descendToBuildWithDurationNode(
        durationNode: DurationNode,
        context: CALayer,
        inout x: CGFloat
    )
    {
        if durationNode.isContainer {
            let bgContainer = BeamGroupContainer(
                durationNode: durationNode,
                left: x,
                top: 0,
                g: viewModel.staffSpaceHeight,
                scale: viewModel.scale,
                beatWidth: viewModel.beatWidth,
                stemDirection: viewModel.stemDirection,
                isMetrical: viewModel.showsMetrics,
                isNumerical: viewModel.showsNumerics,
                renderInterval: renderInterval
            )
            
            addBGContainer(bgContainer, toContext: context)
            var x: CGFloat = 0
            for child in durationNode.children as! [DurationNode] {
                descendToBuildWithDurationNode(child, context: bgContainer, x: &x)
                adjustX(&x, forChildNode: child)
            }
        }
        else {
            let bgEvent = BeamGroupEvent(durationNode: durationNode, x: x)
            addBGEvent(bgEvent, toContext: context)
        }
    }

    private func adjustX(inout x: CGFloat, forChildNode node: DurationNode) {
        let w = node.width(beatWidth: viewModel.beatWidth)
        x = node !== node.parent!.children.last! ? x + w : 0
    }
    
    private func addBGEvent(bgEvent: BeamGroupEvent, toContext context: CALayer) {
        if let bgContainer = context as? BeamGroupContainer { bgContainer.addBGEvent(bgEvent) }
    }
    
    private func addBGContainer(bgContainer: BeamGroupContainer, toContext context: CALayer) {
        if let parentContainer = context as? BeamGroupContainer {
            parentContainer.addBGContainer(bgContainer)
        }
        else if let beamGroup = context as? BeamGroup { beamGroup.addBGContainer(bgContainer) }
        
        bgContainer.beamGroup = self
        // make helper function
        
        // wrap up: set color
        let hue = HueByTupletDepth[bgContainer.depth]
        bgContainer.beamsLayer.color = DNMColor.colorWithHue(hue,
            andDepthOfField: .MostForeground
        ).CGColor
        
        // wrap up: hand-off aug dots
        augmentationDots.appendContentsOf(bgContainer.augmentationDots)
        
        // add beamslayer
        addBeamsLayer(bgContainer.beamsLayer)
        
        // manage tuplet brackets
        if bgContainer.tupletBracket != nil {
            addTupletBracket(bgContainer.tupletBracket!, atDepth: bgContainer.depth)
        }
    }
    
    public func addBGContainer(bgContainer: BeamGroupContainer) {
        bgContainers.append(bgContainer)
    }
    
    private func addTupletBracket(tupletBracket: TupletBracket, atDepth depth: Int) {
        ensureTupletBracketGroupAtDepth(depth)
        tbGroupAtDepth[depth]?.addNode(tupletBracket)
    }
    
    private func ensureTupletBracketGroupAtDepth(depth: Int) {
        if tbGroupAtDepth[depth] == nil {
            tbGroupAtDepth[depth] = TBGroup() // as! TBGroup
            tbGroupAtDepth[depth]!.depth = depth
        }
    }
    
    private func addBeamsLayer(beamsLayer: BeamsLayer) {
        if beamsLayerGroup == nil {
            beamsLayerGroup = BeamsLayerGroup(stemDirection: viewModel.stemDirection)
        }
        beamsLayer.layout()
        beamsLayerGroup!.addNode(beamsLayer)
    }
    
    private func getBGEvents() -> [BeamGroupEvent] {
        var beamGroupEvents: [BeamGroupEvent] = []
        traverseToGetBGEvents(bgContainers.first!, beamGroupEvents: &beamGroupEvents)
        for bgEvent in beamGroupEvents { bgEvent.beamGroup = self }
        beamGroupEvents.sortInPlace { $0.x < $1.x }
        return beamGroupEvents
    }
    
    private func traverseToGetBGEvents(bgContainer: BeamGroupContainer, inout beamGroupEvents: [BeamGroupEvent]) {
        if bgContainer.bgContainers.count > 0 {
            for bgc in bgContainer.bgContainers {
                traverseToGetBGEvents(bgc, beamGroupEvents: &beamGroupEvents)
            }
        }
        for bge in bgContainer.beamGroupEvents { beamGroupEvents.append(bge) }
    }
    
    private func commitTupletBracketGroups() {
        let tbGroupsSorted: [TBGroup] = makeSortedTBGroups()
        if viewModel.showsNumerics {
            for tbGroup in tbGroupsSorted { addNode(tbGroup) }
        }
        
    }
    
    private func makeSortedTBGroups() -> [TBGroup] {
        var tbgs: [TBGroup] = []
        var tbgsByDepth: [(Int, TBGroup)] = []
        for (depth, tbg) in tbGroupAtDepth { tbgsByDepth.append((depth, tbg)) }
        tbgsByDepth.sortInPlace { $0.0 < $1.0 }
        for tbg in tbgsByDepth { tbgs.append(tbg.1) }
        return tbgs
    }
    
    override func setWidthWithContents() {
        let width = viewModel.model.width(beatWidth: viewModel.beatWidth)
        frame = CGRectMake(frame.minX, frame.minY, width, frame.height)
    }
    
    // THIS IS BEING REFACTORED OUT --------------------------------------------------------->
    /*
    private func addMGNode(mgNode: MGNode, atDepth depth: Int) {
    ensureMGLayerAtDepth(depth)
    mgNode.depth = depth
    mgNodeAtDepth[depth]?.addNode(mgNode)
    }
    */
    
    
    /*
    private func ensureMGLayerAtDepth(depth: Int) {
    if mgNodeAtDepth[depth] == nil {
    mgNodeAtDepth[depth] = MGNode() //  as! MGGroup
    mgNodeAtDepth[depth]!.depth = depth
    }
    }
    */
    // <---------------------------------------------------------------------------------------
    
    // THESE ARE BEING REFACTORED OUT ------------------------------------------------------->
    /*
    private func commitMGNodes() {
    let mgNodesSorted: [MGNode] = makeSortedMGNodes()
    for mgNode in mgNodesSorted {
    mgNode.layout()
    addNode(mgNode)
    }
    }
    */
    
    /*
    private func makeSortedMGNodes() -> [MGNode] {
    var mgns: [MGNode] = []
    var mgnsByDepth: [(Int, MGNode)] = []
    for (depth, mgn) in mgNodeAtDepth { mgnsByDepth.append((depth, mgn)) }
    mgnsByDepth.sortInPlace { $0.0 < $1.0 }
    for mgn in mgnsByDepth { mgns.append(mgn.1) }
    return mgns
    }
    */
    // -------------------------------------------------------------------------------------->
    
}


