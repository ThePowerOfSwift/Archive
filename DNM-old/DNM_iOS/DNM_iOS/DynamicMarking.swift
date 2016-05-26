//
//  DynamicMarkingLayer.swift
//  DNM_iOS
//
//  Created by James Bean on 8/19/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

public class DynamicMarkingLayer: ViewNode {

    public var viewModel: DynamicMarkingViewModel!
    
    public var characters: [DynamicMarkingCharacterLayer] = []
    
    public init(viewModel: DynamicMarkingViewModel) {
        self.viewModel = viewModel
        super.init()
        build()
    }
    
    public override init() { super.init() }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    
    public func build() {
        commitCharacters()
        setFrame()
    }
    
    private func populateDynamicMarkingCharacterLayers() {
        characters = viewModel.dynamicMarkingCharacterViewModels.flatMap {
            DynamicMarkingCharacterLayer.withViewModel($0)
        }
    }
    
    private func commitCharacters() {
        populateDynamicMarkingCharacterLayers()
        characters.forEach { addSublayer($0) }
    }

    private func addCharacter(character: DynamicMarkingCharacterLayer) {
        characters.append(character)
        addSublayer(character)
    }
    
    private func setFrame() {
        setFramesOfCharacters()
        let width = characters.count > 0 ? characters.last!.frame.maxX : 0
        frame = CGRectMake(viewModel.x - 0.5 * width, top, width, viewModel.height)
    }
    
    private func setFramesOfCharacters() {
        var accumLeft: CGFloat = 0
        characters.forEach {
            $0.position.x = accumLeft + 0.5 * $0.frame.width
            adjustX(&accumLeft, forCharacter: $0)
        }
    }
    
    // TODO: Implement kerning table
    private func adjustX(inout x: CGFloat,
        forCharacter character: DynamicMarkingCharacterLayer
    )
    {
        switch character {
        case is DMCharacter_f: x += 0.618 * character.frame.width
        case is DMCharacter_p: x += 0.85 * character.frame.width
        case is DMCharacter_m: x += character.frame.width
        case is DMCharacter_o: x += character.frame.width
        default: break
        }
    }
}