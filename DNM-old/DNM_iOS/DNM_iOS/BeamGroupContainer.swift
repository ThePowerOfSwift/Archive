//
//  BeamGroupContainer.swift
//  DNM_iOS
//
//  Created by James Bean on 8/23/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

// TODO: RenderInDurationInterval
public class BeamGroupContainer: ViewNode {
    
    public var renderInterval: DurationInterval?
    
    // model
    public var durationNode: DurationNode!
    
    // organization
    public var beamGroup: BeamGroup?
    public var bgContainer: BeamGroupContainer?
    
    // components
    public var bgContainers: [BeamGroupContainer] = []
    public var beamGroupEvents: [BeamGroupEvent] = []
    public var beamJunctions: [BeamJunction] = []
    public var augmentationDots: [AugmentationDot] = []
    public var beamsLayer = BeamsLayer()
    public var tupletBracket: TupletBracket?
    
    public var tbLigatures: [TBLigature] = []
    
    // attributes
    
    public var width: CGFloat = 0
    public var beatWidth: CGFloat = 0 // proxy
    public var depth: Int { get { return durationNode!.depth } }
    
    public var g: CGFloat = 0
    public var scale: CGFloat = 1
    
    public var isMetrical: Bool = true
    public var isNumerical: Bool = true
    
    public var stemDirection: StemDirection = .Down
    
    public init(
        durationNode: DurationNode,
        left: CGFloat,
        top: CGFloat,
        g: CGFloat,
        scale: CGFloat,
        beatWidth: CGFloat,
        stemDirection: StemDirection,
        isMetrical: Bool = true,
        isNumerical: Bool = true,
        renderInterval: DurationInterval? = nil
    )
    {
        self.durationNode = durationNode
        self.g = g
        self.scale = scale
        self.beatWidth = beatWidth
        self.width = durationNode.width(beatWidth: beatWidth)
        self.stemDirection = stemDirection
        self.isMetrical = isMetrical
        self.isNumerical = isNumerical
        self.renderInterval = renderInterval
        super.init()
        self.left = left
        self.top = top
        self.setsWidthWithContents = false
        self.setsHeightWithContents = true
        self.stackDirectionVertical = stemDirection == .Down ? .Top : .Bottom
        build()
    }
    
    public override init() { super.init() }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    public func addBGContainer(bgContainer: BeamGroupContainer) {
        bgContainers.append(bgContainer)
        addSublayer(bgContainer)
        bgContainer.bgContainer = self
        bgContainer.beamGroup = beamGroup
    }
    
    public func addBGEvent(bgEvent: BeamGroupEvent) {
        beamGroupEvents.append(bgEvent)
        bgEvent.bgContainer = self
    }
    
    public func build() {
        createTupletBracket()
        createBeamsLayer()
        layout()
    }
    
    private func manageTBLigatures() {
        if tupletBracket == nil { return }
        if let firstChild = durationNode?.children.first where firstChild.isContainer { return }
        if stemDirection == .Down {
            let tbl = TBLigature.ligatureWithType(.Begin,
                x: 0,
                beamEndY: beamsLayer.frame.minY,
                bracketEndY: tupletBracket!.position.y,
                g: g
            )!
            addSublayer(tbl)
            tbLigatures.append(tbl)
        }
        else {
            let tbl = TBLigature.ligatureWithType(.Begin,
                x: 0,
                beamEndY: beamsLayer.frame.maxY,
                bracketEndY: tupletBracket!.position.y,
                g: g
            )!
            addSublayer(tbl)
            tbLigatures.append(tbl)
        }
    }
    
    internal func createTupletBracket() {
        guard isNumerical else { return }
        guard durationNode != nil && !durationNode!.isSubdividable else { return }

        let sum: Int = durationNode!.relativeDurationsOfChildren!.sum()
        tupletBracket = TupletBracket(
            left: 0,
            top: 0,
            width: width,
            height: 1.618 * g * scale,
            stemDirection: stemDirection,
            sum: sum,
            beats: durationNode!.durationInterval.duration.beats!.amount,
            subdivisionLevel: durationNode!.durationInterval.duration.subdivision!.level
        )
        addNode(tupletBracket!)
    }
    
    private func lastLeafFromLeaves(leaves: [DurationNode],
        before durationInterval: DurationInterval
    ) -> DurationNode?
    {
        return leaves.filter {
            $0.durationInterval.startDuration < durationInterval.startDuration
        }.sort {
            $0.durationInterval.startDuration < $1.durationInterval.startDuration
        }.last
    }
    
    private func firstLeafFromLeaves(leaves: [DurationNode],
        after durationInterval: DurationInterval
    ) -> DurationNode?
    {
        return leaves.filter {
            $0.durationInterval.startDuration >= durationInterval.stopDuration
        }.sort {
            $0.durationInterval.startDuration < $1.durationInterval.startDuration
        }.first
    }
    
    private func createBeamsLayer() {
        beamsLayer = BeamsLayer(
            g: g,
            scale: scale,
            start: CGPointMake(0, 0),
            stop: CGPointMake(width, 0),
            stemDirection: stemDirection,
            isMetrical: isMetrical
        )
        var x: CGFloat = 0

        
        // create all beamjunctions as normal
        // then, filter the ones that don't fit before
        // copy the last one of the before ones (if there are any)
        // remove the ones before
        // then change position in tree to .FirstInTree, .FirstInContainer
        // insert copied bj at index 0
        // filter the ones that don't fit after
        // copy the first one of the after ones (if there are any)
        // remove the ones after
        // append copied bj

        let leaves = durationNode!.leaves as! [DurationNode]

        if let renderInterval = renderInterval {

            // wrap up
            let leavesInRenderInterval = leaves.filter {
                renderInterval.contains($0.durationInterval.startDuration)
            }
            
            // NB: This implementation doesn't try to add beam extensions on either side
            leaves.forEach {

                if leavesInRenderInterval.containsObject($0) {
                    let beamJunction = BeamJunctionMake($0)
                    if $0 === leavesInRenderInterval.first {
                        
                        // this needs to be internalized
                        beamJunction.positionInTree = .FirstInTree
                        beamJunction.positionInContainer = .FirstInContainer
                        beamJunction.previousSubdivisionLevel = nil
                        beamJunction.makeDefaultComponentsOnLevel()
                        beamJunction.setDefaultBeamletDirection()
                    }
                    else if $0 === leavesInRenderInterval.last {
                        
                        // this needs to be internalized
                        beamJunction.positionInTree = .LastInTree
                        beamJunction.positionInContainer = .LastInContainer
                        beamJunction.nextSubdivisionLevel = nil // ?
                        beamJunction.makeDefaultComponentsOnLevel()
                        beamJunction.setDefaultBeamletDirection()
                    }
                    beamsLayer.addBeamJunction(beamJunction, atX: x)
                }

            }
            
            // IN-PROGRESS (2015-12-16)
            
            /*
            for (l,leaf) in leaves.enumerate() {
                print("leaf: \(leaf)")
                
                // these two conditions are two make little extensions on both sides of the
                // rendered interval
                
                /*
                else if let lastLeafBefore = lastLeafBefore where lastLeafBefore === leaf {
                    let beamJunction = BeamJunctionMake(lastLeafBefore)
                    beamJunction.positionInTree = .FirstInTree
                    beamJunction.positionInContainer = .FirstInContainer
                    
                    // position beamJunction just before the first leaf in interval
                    let x_adjusted = x + leaf.width(beatWidth: beatWidth) - pad_x
                    beamsLayer.addBeamJunction(beamJunction, atX: x_adjusted)
                }
                else if let firstLeafAfter = firstLeafAfter where firstLeafAfter === leaf {

                    let beamJunction = BeamJunctionMake(firstLeafAfter)
                    beamJunction.positionInTree = .LastInTree
                    beamJunction.positionInContainer = .LastInContainer
                    
                    // position beamJunction just after the last leaf in interval
                    let x_adjusted = x + pad_x
                    beamsLayer.addBeamJunction(beamJunction, atX: x_adjusted)
                    
                }
                */
                
                // wrap
                if leaf !== leavesInRenderInterval.last {
                    x += leaf.width(beatWidth: beatWidth)
                }
            }
            */
        }
        else {
            for leaf in leaves {
                beamsLayer.addBeamJunction(BeamJunctionMake(leaf), atX: x)
                x += leaf.width(beatWidth: beatWidth)
            }
        }
        beamsLayer.addBeams()
        addNode(beamsLayer)
    }
    
    private func setFrame() {
        frame = CGRectMake(left, top, width, 100)
    }
}
