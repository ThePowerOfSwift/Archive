//
//  SystemModel.swift
//  DNM_iOS
//
//  Created by James Bean on 11/30/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import QuartzCore
import DNMModel

// add tests for this, add doc comments
public struct SystemModel {
    
    /// DurationInterval for this SystemModel
    public var durationInterval: DurationInterval
    
    /// Model of musical information for this SystemModel
    public var scoreModel: ScoreModel
    
    // clean this up
    // throws?, options: defined by measures or duration nodes?
    public static func rangeWithScoreModel(scoreModel: ScoreModel,
        beatWidth: CGFloat, maximumWidth: CGFloat
    ) -> [SystemModel]
    {
        let maximumDuration = maximumWidth.durationWithBeatWidth(beatWidth)
        var systems: [SystemModel] = []
        var systemStartDuration: Duration = DurationZero
        var measureIndex: Int = 0
        while measureIndex < scoreModel.measures.count {
            
            // create the maximum duration interval for the next SystemLayer
            let maximumDurationInterval = DurationInterval(
                startDuration: systemStartDuration,
                stopDuration: systemStartDuration + maximumDuration
            )
            
            // attempt to get range of measures within maximum duration interval for SystemModel
            do {
                let measureRange = try MeasureModel.rangeFromArray(scoreModel.measures,
                    withinDurationInterval: maximumDurationInterval
                )
                
                // create actual duration interval for SystemLayer, based on Measures present
                let systemDurationInterval = DurationInterval.unionWithDurationIntervals(
                    measureRange.map { $0.durationInterval}
                )
                
                // once we have gotten the systemDurationInterval: 
                if let newScoreModel = scoreModel.scoreModelIn(systemDurationInterval) {
                    let systemModel = SystemModel(
                        durationInterval: systemDurationInterval,
                        scoreModel: newScoreModel
                    )
                    systems.append(systemModel)
                    
                    // advance accumDuration
                    systemStartDuration = systemDurationInterval.stopDuration
                    
                    // advance measure index
                    measureIndex += measureRange.count
                }
            }
            catch {
                print("could not find measures in range: \(error)")
            }
        }
        return systems
    }
    
    public init(durationInterval: DurationInterval, scoreModel: ScoreModel) {
        self.durationInterval = durationInterval
        self.scoreModel = scoreModel
    }
    
    // create defaultComponentSpan
}