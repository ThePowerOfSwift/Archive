//
//  DynamicMarkingStratumFactory.swift
//  DNM_iOS
//
//  Created by James Bean on 12/23/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

/// Creates DynamicMarkingStrata
public class DynamicMarkingStratumFactory: SystemContextualized {
    
    public let dynamicMarkingStratumModels: [DynamicMarkingStratumModel]
    public let viewerProfile: ViewerProfile
    public let systemOffsetDuration: Duration
    public let infoStartX: CGFloat
    public let beatWidth: BeatWidth
    public let systemWidth: CGFloat
    public let defaultStaffHeight: StaffSpaceHeight
    public let scale: Scale
    
    public init(
        dynamicMarkingStratumModels: [DynamicMarkingStratumModel],
        systemContextSpecifier: SystemContextSpecifier = SystemContextSpecifier(),
        sizeSpecifier: StaffTypeSizeSpecifier = StaffTypeSizeSpecifier(),
        systemWidth: CGFloat,
        beatWidth: BeatWidth = 110
    )
    {
        self.dynamicMarkingStratumModels = dynamicMarkingStratumModels
        self.viewerProfile = systemContextSpecifier.viewerProfile
        self.systemOffsetDuration = systemContextSpecifier.offsetDuration
        self.infoStartX = systemContextSpecifier.infoStartX
        self.defaultStaffHeight = sizeSpecifier.staffSpaceHeight
        self.scale = sizeSpecifier.scale
        self.beatWidth = beatWidth
        self.systemWidth = systemWidth
    }
    
    public func makeDynamicMarkingStrataFor(componentFilters: ComponentFilters)
        -> [DynamicMarkingStratum]
    {
        let filteredStratumModels = filterDynamicMarkingStratumModels(
            dynamicMarkingStratumModels,
            withComponentSpans: componentFilters
        )
        let viewModels = makeDynamicMarkingStratumViewModelsWith(filteredStratumModels)
        return viewModels.map { DynamicMarkingStratum(viewModel: $0) }
    }
    
    private func filterDynamicMarkingStratumModels(
        dynamicMarkingStratumModels: [DynamicMarkingStratumModel],
        withComponentSpans componentFilters: ComponentFilters
    ) -> [DynamicMarkingStratumModel]
    {
        var newStrata: [DynamicMarkingStratumModel] = []
        for dynamicMarkingStratum in dynamicMarkingStratumModels {
            let newStratum = filterDynamicMarkingStratumModel(dynamicMarkingStratum,
                withComponentSpans: componentFilters
            )
            if newStratum.dynamicMarkingElementModels.count > 0 {
                newStrata.append(newStratum)
            }
        }
        return newStrata
    }
    
    private func filterDynamicMarkingStratumModel(
        dynamicMarkingStratumModel: DynamicMarkingStratumModel,
        withComponentSpans componentFilters: ComponentFilters
    ) -> DynamicMarkingStratumModel
    {
        var result = DynamicMarkingStratumModel(identifier: dynamicMarkingStratumModel.identifier)
        
        for componentFilter in componentFilters {
            guard componentFilter.showsComponentType("dynamics", forPerformerID: dynamicMarkingStratumModel.identifier) else { continue }
            
            // wrap
            let markingsToAdd = dynamicMarkingStratumModel.dynamicMarkingModels.filter {
                componentFilter.contains($0.durationInterval.startDuration)
            }

            // wrap
            let spannersToAdd = dynamicMarkingStratumModel.dynamicMarkingSpannerModels.filter {
                componentFilter.contains($0.durationInterval.startDuration) ||
                componentFilter.contains($0.durationInterval.stopDuration)
            }
            
            // wrap
            result.dynamicMarkingModels.appendContentsOf(markingsToAdd)
            result.dynamicMarkingSpannerModels.appendContentsOf(spannersToAdd)
            result.updateElementModels()
        }
        return result
    }

    private func makeDynamicMarkingStratumViewModelsWith(
        stratumModels: [DynamicMarkingStratumModel]
    ) -> [DynamicMarkingStratumViewModel]
    {
        return stratumModels.map {
            DynamicMarkingStratumViewModel(
                model: $0,
                origin: CGPointZero,
                height: dynamicMarkingNodeHeightFor($0.identifier),
                systemContextSpecifiier: SystemContextSpecifier(
                    viewerProfile: viewerProfile,
                    offsetDuration: systemOffsetDuration,
                    infoStartX: infoStartX
                ),
                systemWidth: systemWidth,
                beatWidth: beatWidth
            )
        }
    }
    
    private func dynamicMarkingNodeHeightFor(performerID: PerformerID) -> CGFloat {
        return 2.5 * staffSpaceHeightFor(performerID)
    }
}