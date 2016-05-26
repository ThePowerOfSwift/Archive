function ClefAndTranspositionByInstrumentID(instrumentID) {

    this.instrumentID = instrumentID;
    this[this.instrumentID]();
};

ClefAndTranspositionByInstrumentID.prototype.byMeanPitch = function(meanPitch) {

    for (var r = 0; r < this.byMeanPitchRange.length; r ++) {
        var range = this.byMeanPitchRange[r].range;
        if (range.containsWithinRange(meanPitch)) {
            var transposition = this.byMeanPitchRange[r].transposition;
            var clef = this.byMeanPitchRange[r].clef;
            return {
                "clef": clef,
                "transposition": transposition
            };
        };
    };
};

ClefAndTranspositionByInstrumentID.prototype.FL = function() {

    this.initialClef = "treble";
    this.initialTransposition = 0;
    this.byMeanPitchRange = [
        {
            "range": [0, 88],
            "transposition": 0,
            "clef": "treble"
        },
        {
            "range": [88.25, 106],
            "transposition": 1,
            "clef": "treble"
        },
        {
            "range": [106.25, 200],
            "transposition": 1,
            "clef": "treble"
        }
    ];
};

ClefAndTranspositionByInstrumentID.prototype.CL = function() {

    this.initialClef = "treble";
    this.initialTransposition = 0;
    this.byMeanPitchRange = [
        {
            "range": [0, 88],
            "transposition": 0,
            "clef": "treble"
        },
        {
            "range": [88.25, 106],
            "transposition": 1,
            "clef": "treble"
        },
        {
            "range": [106.25, 200],
            "transposition": 1,
            "clef": "treble"
        }
    ];
};

ClefAndTranspositionByInstrumentID.prototype.VA = function() {

    this.initialClef = "alto";
    this.initialTransposition = 0;
    this.byMeanPitchRange = [
        {
            "range": [0, 78],
            "transposition": 0,
            "clef": "alto",
        },
        {
            "range": [78.25, 88],
            "transposition": 0,
            "clef": "treble"
        },
        {
            "range": [88.25, 106],
            "transposition": 1,
            "clef": "treble"
        },
        {
            "range": [106.25, 200],
            "transposition": 2,
            "clef": "treble"
        }
    ];
};

ClefAndTranspositionByInstrumentID.prototype.VN = function() {

    this.initialClef = "treble";
    this.initialTransposition = 0;
};

ClefAndTranspositionByInstrumentID.prototype.VC = function() {

    this.initialClef = "bass";
    this.initialTransposition = 0;
};

ClefAndTranspositionByInstrumentID.prototype.BASS = function() {

    this.initialClef = "bass";
    this.initialTransposition = -1;
};

var transposition = new ClefAndTranspositionByInstrumentID[instrumentID]
    .byMeanPitch(meanPitch).transposition;

var clef = new ClefAndTranspositionByInstrumentID[instrumentID]
    .byMeanPitch(meanPitch).clef;