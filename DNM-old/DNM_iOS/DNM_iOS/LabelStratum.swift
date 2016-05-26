//
//  LabelStratum.swift
//  DNM
//
//  Created by James Bean on 1/29/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation

public class LabelStratum: ViewNode {
    
    public var identifier: String!
    
    public var viewModel: LabelStratumViewModel!
    
    public var labels: [Label] = []
    
    public init(viewModel: LabelStratumViewModel) {
        self.viewModel = viewModel
        self.identifier = viewModel.model.identifier // temp
        super.init()
        build()
    }
    
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    public override init(layer: AnyObject) { super.init(layer: layer) }
    
    private func build() {
        configureViewNodeLayout()
        commitLabels()
        layout()
    }
    
    private func configureViewNodeLayout() {
        self.setsHeightWithContents = true
        self.flowDirectionVertical = .Top
        self.pad_bottom = 10 // scale
    }
    
    private func commitLabels() {
        self.labels = makeLabels()
        labels.forEach { addNode($0) }
    }
    
    private func makeLabels() -> [Label] {
        return viewModel.labelViewModels.map {
            Label(x: $0.x, top: 0, height: viewModel.height, text: $0.model.text)
        }
    }
}