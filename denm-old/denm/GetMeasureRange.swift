import UIKit

class GetMeasureRange {
    
    /// Resource
    var selectedMeasures: [Measure] = []
    var firstMeasureIndex: Int = 0
    var lastMeasureIndex: Int = 0
    
    var infoStartX: CGFloat = 0
    
    /// Constraint
    var maximumWidth: CGFloat = 0
    
    var maximumDuration: Duration = Duration()
    
    func setInfoStartX(x: CGFloat) -> GetMeasureRange {
        self.infoStartX = x
        return self
    }
    
    func setFirstMeasureIndex(index: Int) -> GetMeasureRange {
        self.firstMeasureIndex = index
        return self
    }
    
    func setLastMeasureIndex(index: Int) -> GetMeasureRange {
        self.lastMeasureIndex = index
        return self
    }
    
    func setMaximumDuration(duration: Duration) -> GetMeasureRange {
        self.maximumDuration = duration
        return self
    }
    
    func getRangeFromMeasures(measures: [Measure]) -> [Measure] {
        var accumLeft: CGFloat = infoStartX
        var accumDur: Duration = Duration(0,16)
        var m: Int = firstMeasureIndex
        while accumDur < maximumDuration && m < measures.count {
            let measure = measures[m].setLeft(accumLeft).build()
            if accumDur + measure.duration <= maximumDuration {
                addMeasure(measure)
                accumDur += measure.duration
                accumLeft += measure.width
                m++
            }
            else { break }
        }
        lastMeasureIndex = m
        return selectedMeasures
    }
    
    private func addMeasure(measure: Measure) {
        selectedMeasures.append(measure)
    }
}