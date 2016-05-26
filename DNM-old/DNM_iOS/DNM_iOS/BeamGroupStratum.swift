//
//  BeamGroupStratum.swift
//  DNM_iOS
//
//  Created by James Bean on 8/23/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

/// Horizontal stratum containing 0...n BeamGroups
public class BeamGroupStratum: ViewNode, BuildPattern {

    /// String representation of this BeamGroupStratum
    public override var description: String { get { return getDescription() } }
    
    // MARK: - ViewModel
    
    /// ViewModel containing DurationNodeStratum model and graphical attributes
    public var viewModel: BeamGroupStratumViewModel!

    // MARK: - Contents
    
    /// All BeamGroups contained in this BeamGroupStratum
    public var beamGroups: [BeamGroup] = []
    
    /// All BeamGroupEvents contained in this BeamGroupStratum
    public var beamGroupEvents: [BeamGroupEvent] { return getBGEvents() }
    
    /// ViewNode that contains DurationalExtensions (ties) and augmentation dots, if necessary
    public var durationalExtensionNode: DurationalExtensionNode?
    
    /// ViewNode that contains StemArticulations, if necessary
    public var stemArticulationNodeByType: [ArticulationType : StemArticulationNode] = [:]
    
    /// ViewNode that contains all Beams in this BeamGroupStratum
    public var beamsLayerGroup: BeamsLayerGroup?
    
    /// TupletBrackets organized by depth of nesting
    public var tbGroupAtDepth: [Int : TBGroup] = [:]
    
    // TODO: reimplement, don't delete (2015-12-19)
    /// TupletBracketLigatures organized by depth of nesting
    //public var tbLigaturesAtDepth: [Int : [TBLigature]] = [:]

    // manage with viewModel
    public var instrumentIDsByPerformerID: [String: [String]] { return getIIDsByPID() }

    /// If this BeamGroupStratum has been built
    public var hasBeenBuilt: Bool = false

    /// Y value of for stem terminating flush with the outmost beam
    public var beamEndY: CGFloat { get { return getBeamEndY() } }
    
    // deprecate - after experiment
    public var renderInterval: DurationInterval?
    
    // deprecate, once DurationalExtensionNode manager can be refactored out of here
    public var systemLayer: SystemLayer? // temp // shouldn't have to know this
    
    /**
    Create a BeamGroupStratum with a BeamGroupStratumViewModel
    
    - parameter viewModel: BeamGroupStratumViewModel
    
    - returns: BeamGroupStratum
    */
    public init(viewModel: BeamGroupStratumViewModel) {
        self.viewModel = viewModel
        super.init()
        build()
    }
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    
    // MARK: - Build a BeamGroupStratum
    
    public func build() {
        configureViewNodeLayout()
        buildBeamGroups()
        commitBeamGroups()
        commitTBGroups()
        commitBeamsLayerGroup()
        createDENode()
        layout()
        hasBeenBuilt = true
    }
    
    public override func layout() {
        super.layout()
        layoutLigatures()
    }
    
    private func configureViewNodeLayout() {
        configureStackDirectionWithStemDirection()
        self.pad_bottom = viewModel.staffSpaceHeight
    }
    
    private func configureStackDirectionWithStemDirection() {
        self.stackDirectionVertical = viewModel.stemDirection == .Down ? .Top : .Bottom
    }
    
    // MARK: BeamGroup Management
    
    private func buildBeamGroups() {
        let beamGroupViewModels = viewModel.makeBeamGroupViewModels()
        self.beamGroups = beamGroupViewModels.map { BeamGroup(viewModel: $0) }
        beamGroups.forEach { if !$0.hasBeenBuilt { $0.build() } }
    }
    
    private func commitBeamGroups() {
        buildBeamGroups()
        handOffBeamGroups()
    }
    
    private func handOffBeamGroups() {
        for beamGroup in beamGroups { handOffBeamGroup(beamGroup) }
    }
    
    private func handOffTupletBracketGroupsFromBeamGroup(beamGroup: BeamGroup) {
        for (depth, tbGroup) in beamGroup.tbGroupAtDepth {
            addTBGroup(tbGroup, atDepth: depth)
        }
    }
    
    private func handOffBeamGroup(beamGroup: BeamGroup) {
        guard beamGroup.hasBeenBuilt else { return }
        handOffTupletBracketGroupsFromBeamGroup(beamGroup)
        ensureBeamsLayerGroup()
        beamGroup.beamsLayerGroup!.layout()
        beamGroup.bgStratum = self
        beamsLayerGroup!.addNode(beamGroup.beamsLayerGroup!)
    }
    
    private func getBGEvents() -> [BeamGroupEvent] {
        var beamGroupEvents: [BeamGroupEvent] = []
        for beamGroup in beamGroups {
            beamGroupEvents.appendContentsOf(beamGroup.beamGroupEvents)
        }
        for bgEvent in beamGroupEvents { bgEvent.bgStratum = self }
        beamGroupEvents.sortInPlace { $0.x_inBGStratum! < $1.x_inBGStratum! }
        return beamGroupEvents
    }
    
    // MARK: BeamsLayerGroup
    
    private func ensureBeamsLayerGroup() {
        if beamsLayerGroup == nil {
            beamsLayerGroup = BeamsLayerGroup(stemDirection: viewModel.stemDirection)
            beamsLayerGroup!.pad_bottom = 6 // hack
            beamsLayerGroup!.pad_top = 6 // hack
        }
    }
    
    private func commitBeamsLayerGroup() {
        addNode(beamsLayerGroup!)
    }
    
    // MARK: DurationalExtensions: Refactor to DurationExtensionCoordinator
    
    private func createDENode() {
        ensureDENode()
        addAugmentationDotsToDENode()
        addDurationalExtensionsToDENode()
        commitDENode()
        layout()
    }
    
    private func commitDENode() {
        if durationalExtensionNode != nil {
            addNode(durationalExtensionNode!)
            durationalExtensionNode!.layout()
        }
    }
    
    private func ensureDENode() {
        if durationalExtensionNode == nil {
            // hack
            durationalExtensionNode = DurationalExtensionNode(left: 0, top: 0, height: 0.5 * beamGroups.first!.viewModel.staffSpaceHeight)
            durationalExtensionNode!.pad_bottom = 0.5 * viewModel.staffSpaceHeight
            durationalExtensionNode!.pad_top = 0.5 * viewModel.staffSpaceHeight
        }
    }
    
    private func addAugmentationDotsToDENode() {
        guard let durationalExtensionNode = durationalExtensionNode else { return }
        let augDotPad = viewModel.staffSpaceHeight
        
        // set amount of of augmentation dots... (2 for 7, 3 and so on)
        for bgEvent in beamGroupEvents {
            if bgEvent.hasAugmentationDot {
                let x = bgEvent.x_objective!
                bgEvent.augmentationDot = durationalExtensionNode.addAugmentationDotAtX(x + augDotPad)
            }
        }
    }
    
    // refactor this to DurationalExtensionManager...
    private func addDurationalExtensionsToDENode() {
        guard let durationalExtensionNode = durationalExtensionNode else { return }
        
        let pad = 0.618 * viewModel.staffSpaceHeight
        for e in 0..<beamGroupEvents.count {
            
            let curEvent = beamGroupEvents[e]
            
            // first event
            if e == 0 {
                if curEvent.stopsExtension {
                    let start: CGFloat = -2 * pad
                    let stop = curEvent.x_objective! - pad
                    durationalExtensionNode.addDurationalExtensionFromLeft(start, toRight: stop)
                }
            }
            else {
                let prevEvent = beamGroupEvents[e - 1]
                if curEvent.stopsExtension {
                    let x = prevEvent.augmentationDot?.frame.maxX ?? prevEvent.x_objective!
                    let start = x + pad
                    let stop = curEvent.x_objective! - pad // refine
                    durationalExtensionNode.addDurationalExtensionFromLeft(start, toRight: stop)
                }
                
                // last event
                if e == beamGroupEvents.count - 1 {
                    if curEvent.startsExtension {
                        let start_x = curEvent.augmentationDot?.frame.maxX ?? curEvent.x_objective!
                        let start = start_x + pad
                        let stop_x = systemLayer?.frame.width ?? UIScreen.mainScreen().bounds.width
                        let stop = stop_x + 2 * pad
                        durationalExtensionNode.addDurationalExtensionFromLeft(start, toRight: stop)
                    }
                }
            }
        }
    }
    
    // MARK: TupletBrackets
    
    private func addTBGroup(tbGroup: TBGroup, atDepth depth: Int ) {
        ensureTupletBracketGroupAtDepth(depth)
        tbGroupAtDepth[depth]?.addNode(tbGroup)
    }
    
    private func commitTBGroups() {
        let tbGroupsSorted: [TBGroup] = makeSortedTBGroups()
        for tbGroup in tbGroupsSorted { addNode(tbGroup) }
    }
    
    private func makeSortedTBGroups() -> [TBGroup] {
        var tbgs: [TBGroup] = []
        var tbgsByDepth: [(Int, TBGroup)] = []
        for (depth, tbg) in tbGroupAtDepth { tbgsByDepth.append((depth, tbg)) }
        tbgsByDepth.sortInPlace { $0.0 < $1.0 }
        for tbg in tbgsByDepth { tbgs.append(tbg.1) }
        return tbgs
    }
    
    private func ensureTupletBracketGroupAtDepth(depth: Int) {
        if tbGroupAtDepth[depth] == nil {
            tbGroupAtDepth[depth] = TBGroup()
            tbGroupAtDepth[depth]!.pad_bottom = 3 // hack
            tbGroupAtDepth[depth]!.pad_top = 3 // hack
            tbGroupAtDepth[depth]!.depth = depth
            tbGroupAtDepth[depth]!.bgStratum = self
        }
    }

    private func getIIDsByPID() -> [String : [String]] {
        var iIDsByPID: [String : [String]] = [:]
        for beamGroup in beamGroups {
            let durationNode = beamGroup.viewModel.model
            let bg_iIDsByPID = durationNode.instrumentIDsByPerformerID
            for (pid, iids) in bg_iIDsByPID {
                if iIDsByPID[pid] == nil {
                    iIDsByPID[pid] = iids
                }
                else {
                    iIDsByPID[pid]!.appendContentsOf(iids)
                    iIDsByPID[pid] = iIDsByPID[pid]!.unique()
                }
            }
        }
        return iIDsByPID
    }
    
    // MARK: Positional Attributes
    
    private func getPad_below() -> CGFloat {
        return viewModel.stemDirection == .Down ? 0.0618 * frame.height : 0.0618 * frame.height
    }
    
    private func getPad_above() -> CGFloat {
        return viewModel.stemDirection == .Down ? 0.0618 * frame.height : 0.0618 * frame.height
    }
    
    private func getBeamEndY() -> CGFloat {
        if beamsLayerGroup != nil {
            return viewModel.stemDirection == .Up ? beamsLayerGroup!.frame.height : 0
        }
        return 0
    }
    
    private func layoutLigatures() {
        /*
        for (level, tbLigatures) in tbLigaturesAtDepth {
        let beamEndY = stemDirection == .Down
        ? beamsLayerGroup!.frame.minY
        : beamsLayerGroup!.frame.maxY
        
        let bracketEndY = tbGroupAtDepth[level]!.position.y
        
        for tbLigature in tbLigatures {
        addSublayer(tbLigature)
        tbLigature.setBeamEndY(beamEndY, andBracketEndY: bracketEndY)
        }
        }
        */
        //uiView?.setFrame()
    }
    
    private func getDescription() -> String {
        var description: String = "BeamGroupStratum"
        description += "\(viewModel)"
        return description
    }
}
