#include "StringFing.js"
#include "StringBox.js"

function StringTablature(left, top, height, scordOpenStrings, ordOpenStrings) {
    
    // Open scope for reference to this object for deeply embedded objects
    curGraph = this;
    
    this.partialLines = GRAPH_ITEMS.groupItems.add();
    
    this.graphType = "tablature";
    this.ordOpenStrings = ordOpenStrings;
    this.scordOpenStrings = scordOpenStrings;
    this.left = left;
    this.top = top;
    this.height = height;
    this.bottom = top - height;
    this.g = 5; // THIS SHOULD BE TEMPORARY!!!
    
    this.clef_displacement = 15; // MAKE RELATIVE
    
    /*this.restLine_strokeWidth = 5;
    this.restLine_length = 6.6;
    this.restLine_displacement = 3/2*this.restLine_strokeWidth;
    this.restLine_staffDisplacement = 8.5;

    this.rest_color = orange_dark;
    
    this.stem_strokeWidth = .5 // RELATE TO BEAM GROUP!
    
    this.augDot_diameter = 5;
    this.augDot_displacement = 10;*/
    
    this.partial_resolution = 5;
    this.partialInstance = [];
    
    // Draw Initial bits
    this.lines();
    //this.boundLines();
    //this.clef();
    //this.linePoints(this.left - this.clef_displacement);
}

StringTablature.prototype.clef = function() {
    
    // Draw "clef" (which may be image, or contain numbers? not sure yet…)
    var clef = CLEF_ITEMS.pathItems.add();
    
    clef.setEntirePath([
        [this.left  - this.clef_displacement, this.top + 5],
        [this.left - this.clef_displacement, this.bottom - 5]
    ]);
    clef.strokeWidth = .5;
    
};

StringTablature.prototype.boundLines = function() {
    
    this.boundLine = [];
    
    for (var b = 0; b < 2; b ++) {
        
        this.boundLine[b] = 'bound' + b;
        this.boundLine[b] = GRAPH_ITEMS.pathItems.add();
        this.boundLine[b].name = "BOUND LINE";
        this.boundLine[b].stroked = true;
        this.boundLine[b].strokeWidth = .5;
        this.boundLine[b].strokeColor = gray[50];
        this.boundLine[b].filled = false;
    };
};

StringTablature.prototype.boundLinePoints = function(curX) {
    
    for (var b = 0; b < 2; b ++) {
        
        var boundPoint = this.boundLine[b].pathPoints.add();
        boundPoint.anchor = [curX, this.top - b*this.height];
        boundPoint.leftDirection = boundPoint.anchor;
        boundPoint.rightDirection = boundPoint.anchor;  
    };
};

StringTablature.prototype.lines = function() {
    
    var curDivList = [];
    // Declare lines, with partial_resolution, min/max, etc.
    
    for (var p = 1; p < this.partial_resolution + 1; p ++) {
        
        var partialGroup = this.partialLines.groupItems.add();
        partialGroup.name = "Partial: " + p;
        
        var partialLine_strokeColor = Math.round(
            75 - (p-1)*(75/this.partial_resolution)
        );
        
        var partialLine_strokeWidth = .5
        var partialLine_strokeDashes = 10/p 
        
        var partial = [];
        
        for (var pI = 1; pI < p; pI ++) {
        
            if (curDivList.contains(pI/p) == false) {

                partial[pI] = p + '_' + pI
                                                             
                partial[pI] = partialGroup.pathItems.add();
                partial[pI].name = "Partial: " + pI + " / " + p;
            
                partial[pI].stroked = true;
                partial[pI].strokeWidth = partialLine_strokeWidth;
                partial[pI].strokeDashes = [partialLine_strokeDashes];
                partial[pI].strokeColor = gray[partialLine_strokeColor];
                partial[pI].filled = false;
  
                curDivList.push(pI/p)
            };
        };  
    
        // Add partial list up to master this.partialInstance list
        this.partialInstance[p] = partial;
    };
    
    // Also call bound lines
    this.boundLines();
};

StringTablature.prototype.linePoints = function(curX) {
        
    var curDivList = [];
    
    for (var p = 1; p < this.partial_resolution + 1; p ++) {

        for (var pI = 1; pI < this.partialInstance[p].length; pI ++) {

            if (curDivList.contains(pI/p) == false) {
                var newPoint = this.partialInstance[p][pI].pathPoints.add();
                newPoint.anchor = [curX, this.bottom + pI/p*this.height];
                newPoint.leftDirection = newPoint.anchor;
                newPoint.rightDirection = newPoint.anchor;  
            
                curDivList.push(pI/p)
            };
        };
    };
    
    // Also add bouldLinePoints
    this.boundLinePoints(curX);
};

StringTablature.prototype.fingering = function(
    curX, position, type, info, string) {
    
    var fing = new StringFing(
        curX, this.bottom, this.height, 
        this.scordOpenStrings, this.ordOpenStrings, 
        position, type, info, string
    );
    
    //curInstr.graphs.sounding.pitch(fing.pitch_sounding.pitch);
    //curInstr.graphs.fingered.pitch(fing.pitch_fingered.pitch);
    
};

StringTablature.prototype.fingLinePoint = function(curX, position) {
    
    var fingLinePoint = curInstr.fingLine.pathPoints.add();
    fingLinePoint.anchor = [curX, position];
    fingLinePoint.leftDirection = fingLinePoint.anchor;
    fingLinePoint.rightDirection = fingLinePoint.anchor;
}

StringTablature.prototype.rest = function(curX, curSubd) {
    
    // Add line points
    this.linePoints(curX);
    //this.boundLinePoints();
    
    // Declare lines
    this.lines();
    this.boundLines();
    
    // Stemlet
    //curBeamGroup.stemlet();
    
    /*// Declare Dashed line
    var dashedLine = beamGroup.pathItems.add();
    dashedLine.stroked = true;
    dashedLine.strokeWidth = 2*this.stem_strokeWidth;
    dashedLine.strokeColor = this.rest_color;
    dashedLine.strokeDashes = [2.5]; // CONSIDER RELATIVE VALUE
    dashedLine.filled = false;
    
    if (curBeamGroup.level < 0) {
        
        var restLine_altitude = this.top + this.restLine_staffDisplacement
    }
    else if (curBeamGroup.level > 0) {
        
        var restLine_altitude = this.bottom - this.restLine_staffDisplacement
    };
    
    dashedLine.setEntirePath([
        [
            curX, 
            curBeamGroup.beam_altitude + 
                (curBeamGroup.stem_direction*curBeamGroup.stemletLength +
                 curBeamGroup.stem_direction*1.85) // CONSIDER RELATIVE VALUE
        ],
        [
            curX, 
            restLine_altitude - 
                (curBeamGroup.stem_direction*this.restLine_staffDisplacement +
                 3.82) // CONSIDER RELATIVE VALUE
        ]
    ]);
    
    // Solid connecting line
    var solidLine = beamGroup.pathItems.add();
    solidLine.stroked = true;
    solidLine.strokeColor = this.rest_color;
    solidLine.strokeWidth = 2*this.stem_strokeWidth;
    solidLine.filled = false;
    solidLine.setEntirePath([
        [
            curX, 
            restLine_altitude - curBeamGroup.stem_direction*
                (this.restLine_staffDisplacement + 1.25)    
        ],
        [   
            curX,
            restLine_altitude + curBeamGroup.stem_direction*
                this.restLine_displacement*(curEvent.curSubdivision - 1)
        ]
    ]);
    
    // Draw Rest lines
    for (var restSubd = 0; restSubd < curSubd + 1; restSubd ++) {
        
        var restLine = BEAM_ITEMS.pathItems.add();
        restLine.stroked = true;
        restLine.strokeWidth = this.restLine_strokeWidth;
        restLine.falled = false
        restLine.strokeColor = rest_color;
        restLine.setEntirePath([
            [
                curEvent.curX - .5*this.restLine_length,
                restLine_altitude + restSubd*curBeamGroup.stem_direction*
                    this.restLine_displacement
            ],
            [
                curEvent.curX + .5*this.restLine_length,
                restLine_altitude + restSubd*curBeamGroup.stem_direction*
                    this.restLine_displacement
            ]
        ]); 
    };*/
    
    /*// Aug dot if necessary
    if (curEvent.durationAbs % 3 == 0) {
        
        var rest_augDot = beamGroup.pathItems.ellipse(
            this.top - 15 + .5*augDot_diameter, // CONSIDER RELATIVE VALUE
            curX + augDot_displacement - .5*augDot_diameter,
            augDot_diameter,
            augDot_diameter
        );
        
        rest_augDot.stroked = false
        rest_augDot.filled = true
        rest_augDot.fillColor = rest_color
    }*/
};

StringTablature.prototype.lh = function() {
    
    // Add fingDot
    
    // Add fingLine 
    
    // Add call stringFing (replace .fingering())
};

StringTablature.prototype.rh = function() {
    
    // Add stringBox
    
    // Add to stringLine
};

StringTablature.prototype.stringBox = function() {
    
    // 
    
    // Add stringBox at curX, curY
    var stringBox = new StringBox(strings, curX, curY);
};