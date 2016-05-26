#include "conversions.js"

function MetronomeClick(x, y, g, beats, subdivision, depth, group) {
    
    this.x = x;
    this.y = y;
    this.g = g;
    this.beats = beats;
    this.subdLevel = subdToLevel(subdivision);
    this.depth = depth;
    this.group = group.groupItems.add();
    
    this.strokeWidth = .05 * this.g;
    
    this.lightColor = tupletColor[depth].lightColor;
    this.darkColor = tupletColor[depth].darkColor;
    
    $.writeln("subdvision: " + subdivision + "; subdLevel: " + this.subdLevel);
    
    var subdLevelToClick = {
        
        "1": "click8",
        "2": "click16",
        "3": "click32",
        "4": "click64",
        "5": "click128",
        "6": "click256",
        "7": "click512"
    };

    var clickLevel = subdLevelToClick[this.subdLevel];
    $.writeln("clickLevel");
    
    // Call appropriate method for beat grouping
    this[clickLevel](beats);    
}

MetronomeClick.prototype.active = function() {
    
    // Change strokeColor to dark color
    this.strokeColor = this.darkColor;
};

MetronomeClick.prototype.idle = function() {
    
    // Change strokeColor to light color
    this.strokeColor = this.lightColor;
};

// Metronome click for 2-or-3 16ths
MetronomeClick.prototype.click16 = function(beats) {

    var height = clickHeightBySubdLevel(this.subdLevel) * this.g;

    if (beats === 2) {
        
        // Outside square
        var outside = this.group.pathItems.rectangle(
            this.y + (0.5 * height),
            this.x - (0.5 * height),
            height,
            height
        );
        
        // Inside square
        var inside = this.group.pathItems.rectangle(
            this.y + (0.8 * (0.5 * height)),
            this.x - (0.8 * (0.5 * height)),
            0.8 * height,
            0.8 * height
        );
    }
    else if (beats === 3) {
        
        // Outside triangle
        var outside = this.group.pathItems.add();
        outside.setEntirePath([
            [
                // bottom left
                this.x - (1.2 * (0.5 * height)),
                this.y - (0.5 * height)
            ],
            [
                // bottom right
                this.x + (1.2 * (0.5 * height)),
                this.y - (0.5 * height)
            ],
            [
                // top middle
                this.x,
                this.y + (1.175 * (0.5 * height))
            ]
        ]);
        
        outside.closed = true;
        
        // Inside triangle
        var inside = this.group.pathItems.add();
        inside.setEntirePath([
            [
                // bottom left
                this.x - (0.85 * (0.5 * height)),
                this.y - (0.8 * (0.5 * height))
            ],
            [
                // bottom right
                this.x + (0.85 * (0.5 * height)),
                this.y - (0.8 * (0.5 * height))
            ],
            [
                // top middle
                this.x,
                this.y + (0.75 * (0.5 * height))
            ]
        ]);
        
        inside.closed = true;
    };
    
    // Set default attributes for shapes
    outside.strokeWidth = this.strokeWidth;
    outside.strokeColor = this.lightColor;
    outside.fillColor = white;
    
    // Set default attributes for shapes
    inside.strokeWidth = this.strokeWidth;
    inside.strokeColor = this.lightColor;
    inside.fillColor = white;
}

// Metronome click for 2-or-3 32nds
MetronomeClick.prototype.click32 = function(beats) {
    
    var height = clickHeightBySubdLevel(this.subdLevel) * this.g;
    var width = 0.33 * height;
    
    if (beats === 2) {
        
        // Draw square
        var rectangle = this.group.pathItems.rectangle(
            this.y + (0.5 * height),
            this.x - (0.5 * width),
            width,
            height
        );
        
        rectangle.strokeWidth = this.strokeWidth;
        rectangle.strokeColor = this.lightColor;
        rectangle.fillColor = white;
        rectangle.strokeJoin = StrokeJoin.BEVELENDJOIN;
    }
    else if (beats === 3) {
        
        // Draw triangle
        var triangle = this.group.pathItems.add();
        
        triangle.setEntirePath([
            [
                // bottom left
                this.x - (1.875 * (0.5 * width)),
                this.y - (0.5 * height)
            ],
            [
                // bottom right
                this.x + (1.875 * (0.5 * width)),
                this.y - (0.5 * height)
            ],
            [
                // top center
                this.x,
                this.y + (1.125 * (0.5 * height))
            ]
        ]);
        
        triangle.strokeWidth = this.strokeWidth;
        triangle.strokeColor = this.lightColor;
        triangle.fillColor = white;
        triangle.closed = true;
        triangle.strokeJoin = StrokeJoin.BEVELENDJOIN;
    };
}

// Metronome click for 2-or-3 64ths
MetronomeClick.prototype.click64 = function(beats) {
    
    var height = clickHeightBySubdLevel(this.subdLevel) * this.g;
    
    if (beats === 2) {
        
        var square = this.group.pathItems.rectangle(
            this.y + (0.5 * height),
            this.x - (0.5 * height),
            height,
            height
        );
        
        square.strokeWidth = this.strokeWidth;
        square.strokeColor = this.lightColor;
        square.fillColor = this.lightColor;
    }
    else if (beats === 3) {
        
        var triangle = this.group.pathItems.add();
        
        triangle.setEntirePath([
            [
                // bottom left
                this.x - (1.25 * (0.5 * height)),
                this.y - (0.5 * height)
            ],
            [
                // bottom right
                this.x + (1.25 * (0.5 * height)),
                this.y - (0.5 * height)
            ],
            [
                // top center
                this.x,
                this.y + (1.25 * (0.5 * height))
            ]
        ]);
        
        triangle.strokeWidth = this.strokeWidth;
        triangle.strokeColor = this.lightColor;
        triangle.fillColor = this.lightColor;
        triangle.closed = true;
    };
}

// Metronome click for 2-or-3 128ths
MetronomeClick.prototype.click128 = function(beats) {
    
    var height = clickHeightBySubdLevel(this.subdLevel) * this.g;
    
    if (beats === 2) {
        
        var line = this.group.pathItems.add();
        
        line.setEntirePath([
            [
                // top
                this.x,
                this.y + (0.5 * height)
            ],
            [
                // bottom
                this.x, 
                this.y - (0.5 * height)
            ]
        ]);
        
        line.strokeWidth = 1.236 * this.strokeWidth;
        line.strokeColor = this.lightColor;
        line.fillColor = this.lightColor;
    }
    else if (beats === 3) {
        
        var width = height / 3;
        
        var triangle = this.group.pathItems.add();
        
        triangle.setEntirePath([
            [
                // bottom left
                this.x - (0.5 * width),
                this.y - (0.5 * height)
            ],
            [
                // bottom right
                this.x + (0.5 * width),
                this.y - (0.5 * height)
            ],
            [
                // top center
                this.x,
                this.y + (1.25 * (0.5 * height))
            ]
        ]);
        
        triangle.strokeWidth = this.strokeWidth;
        triangle.strokeColor = this.lightColor;
        triangle.fillColor = white;
        triangle.closed = true;
        triangle.strokeJoin = StrokeJoin.BEVELENDJOIN;
    };
}

// Metronome click for 2-or-3 256ths
MetronomeClick.prototype.click256 = function(beats) {
    
    if (beats === 2) {
        
        
    }
    else if (beats === 3) {
        
        
    };
}