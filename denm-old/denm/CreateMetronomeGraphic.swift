import QuartzCore
import UIKit

/**
MetronomeGraphic Factory
*/
class CreateMetronomeGraphic {
    
    /**
    Create MetronomeGraphic with amount of beats and level of subdivision
    
    :param: beats            Amount of Beats
    :param: subdivisionLevel Level of Subdivision
    
    :returns: MetronomeGraphic?
    */
    func withDuration(beats: Int, subdivisionLevel: Int) -> MetronomeGraphic? {
        if beats == 2 && subdivisionLevel == 2 { return MetronomeGraphic_2_16()!   }
        if beats == 3 && subdivisionLevel == 2 { return MetronomeGraphic_3_16()!   }
        if beats == 2 && subdivisionLevel == 3 { return MetronomeGraphic_2_32()!   }
        if beats == 3 && subdivisionLevel == 3 { return MetronomeGraphic_3_32()!   }
        if beats == 2 && subdivisionLevel == 4 { return MetronomeGraphic_2_64()!   }
        if beats == 3 && subdivisionLevel == 4 { return MetronomeGraphic_3_64()!   }
        if beats == 2 && subdivisionLevel == 5 { return MetronomeGraphic_2_128()!  }
        if beats == 3 && subdivisionLevel == 5 { return MetronomeGraphic_3_128()!  }
        if beats == 2 && subdivisionLevel == 6 { return MetronomeGraphic_2_256()!  }
        if beats == 3 && subdivisionLevel == 6 { return MetronomeGraphic_3_256()!  }
        if beats == 2 && subdivisionLevel == 7 { return MetronomeGraphic_2_512()!  }
        if beats == 3 && subdivisionLevel == 7 { return MetronomeGraphic_3_512()!  }
        if beats == 2 && subdivisionLevel == 8 { return MetronomeGraphic_2_1024()! }
        if beats == 3 && subdivisionLevel == 8 { return MetronomeGraphic_3_1024()! }
        return nil
    }
}