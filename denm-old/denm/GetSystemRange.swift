import UIKit

class GetSystemRange {
    
    /// Resource
    var selectedSystems: [System] = []
    var firstSystemIndex: Int = 0
    var lastSystemIndex: Int = 0
    
    /// Constraint
    var maximumHeight: CGFloat = 0
    
    func setFirstSystemIndex(index: Int) -> GetSystemRange {
        self.firstSystemIndex = index
        return self
    }
    
    func setLastSystemIndex(index: Int) -> GetSystemRange {
        self.lastSystemIndex = index
        return self
    }
    
    func setMaximumHeight(height: CGFloat) -> GetSystemRange {
        self.maximumHeight = height
        return self
    }
    
    func getRangeFromSystems(systems: [System]) -> [System] {
        var s: Int = firstSystemIndex
        var accumHeight: CGFloat = 0
        while accumHeight < maximumHeight && s < systems.count {
            
            println("page.accumHeight: \(accumHeight)")
            println("system.height: \(systems[s].frame.height)")
            
            if accumHeight + systems[s].frame.height < maximumHeight {
                addSystem(systems[s])
                accumHeight += systems[s].frame.height
                s++
            }
            else { break }
        }
        lastSystemIndex = s
        return selectedSystems
    }
    
    func addSystem(system: System) {
        selectedSystems.append(system)
    }
}
