#include "conversions.js"
#include "arrayMethods.js"
#include "colors.js"
#include "Interpolation.js"

function StringBowLine(state, info, x0, y0, x1, y1, exp) {
    
    // Are interpolating elements coming in as arrays, or single variables?
    
    // SOMETHING
    this.state = state;
    this.info = info;
    this.x0 = x0;
    this.x1 = x1;
    this.y0 = y0;
    this.y1 = y1;
    this.exp = exp;
    
    // infob.bowPositions comes in as an array of 2 bowPlacement values;
    this.bowPositions = this.info.bowPositions;

    this.height = this.y1 - this.y0;
    this.width = this.x1 - this.x0;
    this.slope = this.height/this.width;
    
    // add bowLine group to appropriate LAYER
    //this.bowLine = LAYERS[curPart.name][curPlayer.name][curGraph.name]
                    //.rh.bowLines.groupItems.add();            

    
    if (this.state == "ord") {
        
        // Call ord method
        this.ord();
    }
    else if (this.state == "tremolo_through") {
        
        // Call tremolo_through method
        this.tremolo_through();
    }
    else if (this.state == "tremolo_cross") {
        
        // Call tremolo_cross method
        this.tremolo_cross();
    }
    else if (this.state == "jete") {
        
        
        // Call jete method
        this.jete();
    }
    // interpType may just be exponent? ord == 1; exp = 2; -2, etc.
    
    // bow_info is object with parameters: 
    // if type == ord: interpType, d1, d2, bp1, bp2
    // if type == tremolo_through: interpType, s1, s2, a1, a2, d1, d2, bp1, bp2
    // if type == tremolo_cross: interpType, s1, s2, d1, d2, bp1, bp2
    // if type == jete: (interpType?), speed, d1, d2, bp1, bp2
    
}

StringBowLine.prototype.ord = function() {

    //$.writeln("exp: " + this.exp + " xAdjust: " + ((Math.log(this.exp)/Math.log(2)) + 2)/4 );
    
    // use bezier in stead of interpolation…
    this.dynamics = this.info.dynamics;
    
    // for testing:
    this.bowLine = SCORE.pathItems.add();
    

    
    var points = [
        
        [this.x0, this.y0 + this.dynamics[0]],
        [this.x1, this.y1 + this.dynamics[1]],
        [this.x1, this.y1 - this.dynamics[1]],
        [this.x0, this.y0 - this.dynamics[0]]
    ];
    
    this.bowLine.setEntirePath(points);
    
    var bezierAdjust = Math.log(this.exp)/Math.log(2);
    $.writeln("bezierAdjust: " + bezierAdjust)
    
    // decrescendo
    if (this.dynamics[0] > this.dynamics[1]) {
        
        // "soft"
        if (bezierAdjust < 0) {
            
        }
        
        // extreme "sforzando"
        else if (bezierAdjust > 0) {
            
            // approaching linear
            if (bezierAdjust <= 1) {
                
                var bezierRange = this.dynamics[0] - this.dynamics[1];
                
                // top left point
                this.bowLine.pathPoints[0].rightDirection = [
                    this.x0,
                    this.y0 + this.dynamics[1] - bezierRange*(bezierAdjust - 1)
                ];
                
                // bottom left point
                this.bowLine.pathPoints[3].leftDirection = [
                    this.x0,
                    this.y0 - this.dynamics[1] + bezierRange*(bezierAdjust - 1)
                ];
            }
            // approaching quadratic
            else if (bezierAdjust > 1) {
                $.writeln("approaching quadratic");
                
                var bezierHeight = (this.y0 + this.dynamics[1]) - 
                                   (this.y1 + this.dynamics[1]);
                
                // top left point
                this.bowLine.pathPoints[0].rightDirection = [
                    this.x0,
                    this.y0 + this.dynamics[1]
                ];
                
                // bottom left point
                this.bowLine.pathPoints[3].leftDirection = [
                    this.x0,
                    this.y0 - this.dynamics[1]
                ];
                
                // top right point
                this.bowLine.pathPoints[1].leftDirection = [
                    this.x1 - (bezierAdjust - 1)*this.width,
                    this.y1 + this.dynamics[1] + bezierHeight*(bezierAdjust - 1)
                ];
                
                // bottom right point
                this.bowLine.pathPoints[2].rightDirection = [
                    this.x1 - (bezierAdjust - 1)*this.width,
                    this.y1 - this.dynamics[1] + bezierHeight*(bezierAdjust - 1)
                ];
            };
        };
    }
    // crescendo
    else if (this.dynamics[1] > this.dynamics[0]) {
        
        // rounded, soft
        if (bezierAdjust < 0) {
            
        }
        
        // extreme "splat"
        else if (bezierAdjust > 0) {
            
            // squared to linear
            if (bezierAdjust <= 1) {
                
                var bezierRange = this.dynamics[1] - this.dynamics[0];
                
                // adjust top right point
                this.bowLine.pathPoints[1].leftDirection = [
                    this.x1, 
                    this.y1 + this.dynamics[0] + bezierRange*(1-bezierAdjust)
                ];
                
                // adjust bottom right point
                this.bowLine.pathPoints[2].rightDirection = [
                    this.x1,
                    this.y1 - this.dynamics[0] - bezierRange*(1-bezierAdjust)
                ];
            }
            // approaching quadratic
            else if (bezierAdjust > 1) {
                
                var bezierHeight = (this.y1 + this.dynamics[0]) - 
                                   (this.y0 + this.dynamics[0])
                
                // adjust top left point
                this.bowLine.pathPoints[0].rightDirection = [
                    this.x0 + (bezierAdjust - 1)*this.width,
                    this.y0 + this.dynamics[0] + bezierHeight*(bezierAdjust - 1)
                ];
                
                // adjust bottom left point
                this.bowLine.pathPoints[3].leftDirection = [
                    this.x0 + (bezierAdjust - 1)*this.width,
                    this.y0 - this.dynamics[0] + bezierHeight*(bezierAdjust - 1)
                ];
                
                // adjust top right point
                this.bowLine.pathPoints[1].leftDirection = [
                    this.x1, 
                    this.y1 + this.dynamics[0]
                ];
                
                // adjust bottom right point
                this.bowLine.pathPoints[2].rightDirection = [
                    this.x1,
                    this.y1 - this.dynamics[0]
                ];
            };
        };
    }
    else if (this.dynamics[1] === this.dynamics[0]) {
        
        // static, no exp adjustment, LINEAR
    };

    this.bowLine.closed = true;
    this.bowLine.stroked = false;
    this.bowLine.fillColor = this.color();
    
    
    // to test exponential
    /*this.bowLine.pathPoints[0].rightDirection = [this.x0, this.y0 + this.dynamics[1]];
    this.bowLine.pathPoints[1].leftDirection = [this.x0, this.y0 + this.dynamics[1]];
    this.bowLine.pathPoints[2].rightDirection = [this.x0, this.y0 - this.dynamics[1]];
    this.bowLine.pathPoints[3].leftDirection = [this.x0, this.y0 - this.dynamics[1]];*/
    
    // test out Math.log? log2(4), log2(.25), etc
    

    // y0 + curDyn(0)
    // y1 + curDyn(1)
    // y1 - curDyn(1)
    // y0 - curDyn(0)
    
}

StringBowLine.prototype.tremolo_through = function() {
    
    // for testing:
    this.bowLine = SCORE.pathItems.add();
    
    // calculate hypotenuse for line length before rotating
    var lineLength = pythagoras(this.height, this.width);
    
    // dynamics
    this.dynamics = this.info.dynamics;
    this.dynamicsInterp = new Interpolation(
        this.x0,
        this.dynamics[0],
        this.x0 + lineLength,
        this.dynamics[1],
        1
    );
    
    this.amplitudes = this.info.amplitudes;
    this.amplitudesInterp = new Interpolation(
        this.x0,
        this.amplitudes[0],
        this.x0 + lineLength,
        this.amplitudes[1],
        1
    );
    
    // currently single-speed, work up to variable speed of n amount
    this.speed = this.info.speed;
    
    // calculate angle based on slope (for rotation)
    var angle = slopeToAngle(this.slope);
    
    if (this.slope > 1) {
        
        var slopeAdjust = 1;
    }
    else if (this.slope <= 1) {
        
        var slopeAdjust = -1;
    }
    
    // convert speed to amountZags (based on hypotenuse length lineLength)
    
    var amountZags = Math.round(lineLength/10*this.speed);
    var amountPoints = amountZags*8 + 2;
    var segmentWidth = lineLength/(amountZags*4);
    
    // establish array of point anchors
    var points = [];
    
    for (var p = 0; p < amountPoints; p ++) {
        
        if (p < amountPoints/2) {
            
            var t = p;
            var direction = 1;
        }
        else if (p >= amountPoints/2) {
            
            var t = amountPoints/2 - 1 - p%(amountPoints/2);
            var direction = -1;
        };
        
        // define the x value (static // FOR NOW!! this will change!!)
        var x = this.x0 + t*segmentWidth;
        var curDynamic = this.dynamicsInterp.point(x);
        var curAmplitude = this.amplitudesInterp.point(x);
        
        // define each point in the 4-part period
        if (t % 4 == 0) {
            
            var y = this.y0 + direction*curDynamic;
        }
        else if (t % 4 == 1) {
            
            var y = this.y0 + direction*curDynamic - /*slopeAdjust**/curAmplitude;
        }
        else if (t % 4 == 2) {
            
            var y = this.y0 + direction*curDynamic;
        }
        else if (t % 4 == 3) {
            
            var y = this.y0 + direction*curDynamic + /*slopeAdjust**/curAmplitude;
        };

        // add point to array of points
        var point = [x,y];
        points.push(point);

    };
    
    
    this.bowLine.setEntirePath(points);

    this.bowLine.stroked = false;
    this.bowLine.fillColor = this.color();
    
    // rotate line from LEFT base on slope
    this.bowLine.rotate(angle, true, false, false, false, Transformation.LEFT);
    
    // point correction CLEANER WAY OF DOING THIS?!
    // first point (left top)
    this.bowLine.pathPoints[0].anchor = [this.x0, this.y0 + this.dynamics[0]];
    this.bowLine.pathPoints[0].leftDirection = this.bowLine.pathPoints[0].anchor;
    this.bowLine.pathPoints[0].rightDirection = this.bowLine.pathPoints[0].anchor;
    
    // middle point (right top)
    // anchor
    this.bowLine.pathPoints[amountPoints/2 - 1].anchor = 
        [this.x1, this.y1 + this.dynamics[1]];
    
    // left direction
    this.bowLine.pathPoints[amountPoints/2 - 1].leftDirection = 
        this.bowLine.pathPoints[amountPoints/2 - 1].anchor;
    
    // right direction  
    this.bowLine.pathPoints[amountPoints/2 - 1].rightDirection = 
        this.bowLine.pathPoints[amountPoints/2 - 1].anchor;
    
    
    // middle point + 1 (right bottom)
    // anchor
    this.bowLine.pathPoints[amountPoints/2].anchor = 
        [this.x1, this.y1 - this.dynamics[1]];
    
    // left direction
    this.bowLine.pathPoints[amountPoints/2].leftDirection = 
        this.bowLine.pathPoints[amountPoints/2].anchor;
        
    // right direction
    this.bowLine.pathPoints[amountPoints/2].rightDirection = 
        this.bowLine.pathPoints[amountPoints/2].anchor;
    

    // last point (left bottom)
    // anchor
    this.bowLine.pathPoints[amountPoints-1].anchor = 
        [this.x0, this.y0 - this.dynamics[0]];
    
    // left direction
    this.bowLine.pathPoints[amountPoints-1].leftDirection = 
        this.bowLine.pathPoints[amountPoints-1].anchor;
    
    // right direction
    this.bowLine.pathPoints[amountPoints-1].rightDirection = 
        this.bowLine.pathPoints[amountPoints-1].anchor;
}

StringBowLine.prototype.tremolo_cross = function() {
    
    this.bowLine = SCORE.pathItems.add();
    
    var amountBoxes = 10;
    var box_width = 7;
    
    var amountPoints = amountBoxes*4;
    
    this.dynamics = this.info.dynamics;
    
    // calculate speed based on width, calculate 
    
    // calculate gap based on current dynamic (10%?)
    
    // define 4 interpolations that will be called on for points
    this.aboveOutside = new Interpolation(
        this.x0, 
        this.y0 + this.dynamics[0], 
        this.x1, 
        this.y1 + this.dynamics[1], 
        this.exp
    );
    this.aboveInside = new Interpolation(
        this.x0, 
        this.y0 + .1*this.dynamics[0], 
        this.x1,
        this.y1 + .1*this.dynamics[1], 
        this.exp
    );
    this.belowInside = new Interpolation(
        this.x0, 
        this.y0 - .1*this.dynamics[0], 
        this.x1, 
        this.y1 - .1*this.dynamics[1], 
        this.exp
    );
    this.belowOutside = new Interpolation(
        this.x0, 
        this.y0 - this.dynamics[0], 
        this.x1, 
        this.y1 - this.dynamics[1], 
        this.exp
    );
    
    // order of points for first run (top)
    var firstHalf = [
        
        this.aboveOutside,
        this.aboveOutside,
        this.belowInside,
        this.belowInside
    ];
    
    // order of points for return (bottom)
    var secondHalf = [
    
        this.belowOutside,
        this.belowOutside,
        this.aboveInside,
        this.aboveInside
    ];
    
    // declare array of points
    var points = [];
    
    // declare box number (for horizontal progression)
    var b = 0;
    
    // iterate through points
    for (var p = 0; p < amountPoints; p ++) {   
        
        // for first half (top)
        if (p < amountPoints/2) {
        
            var directionArray = firstHalf;
            var direction = 1;
            var t = p;
        }
        // for second half (bottom, return)
        else if (p >= amountPoints/2) {
        
            var directionArray = secondHalf;
            var direction = -1;
            var t = amountPoints/2 - p%(amountPoints/2);    
        };
        
        //$.writeln("p: " + p + "; t: " + t);
        
        // for first and middle event, reset b to 0
        if (t == 0) {
            
            b = 0;
        }
        else if (t != 0 && t % 4 == 0) {
            
            b ++;
        };
        
        // point 1
        if (p % 4 == 0) {

            var x = this.x0 + t*box_width - direction*2*b*box_width;
            
            // temporary, totally broken and unacceptable
            if (direction == -1) {
            
                x -= amountBoxes*box_width*2;
            }
            var y = directionArray[p % 4].point(x);
        }
        // point 2
        else if (p % 4 == 1) {
        
            var x = this.x0 + t*box_width - direction*2*b*box_width;
            
            // temporary, totally broken and unacceptable
            if (direction == -1) {
            
                x -= amountBoxes*box_width*2;
            }
            var y = directionArray[p % 4].point(x);
        }
        // point 3
        else if (p % 4 == 2) {
            
            var x = this.x0 + (t-direction*1)*box_width - direction*2*b*box_width;
            
            // temporary, totally broken and unacceptable
            if (direction == -1) {
            
                x -= amountBoxes*box_width*2;
            }
            var y = directionArray[p % 4].point(x);
        }
        // point 4
        else if (p % 4 == 3) {
            
            var x = this.x0 + (t - direction*1)*box_width - direction*2*b*box_width;
            
            // temporary, totally broken and unacceptable
            if (direction == -1) {
            
                x -= amountBoxes*box_width*2;
            }
            var y = directionArray[p % 4].point(x);
        };

        //$.writeln("x: " + x + "; y: " + y);
        

        // define current point
        var point = [x,y];
        
        // add point to array of points
        points.push(point);
    };
    
    this.bowLine.setEntirePath(points);
    this.bowLine.closed = true;
    this.bowLine.stroked = true;
    this.bowLine.strokeWidth = .25;
    this.bowLine.strokeColor = this.color();
    this.bowLine.fillColor = this.color();

    //firstHalf[p].point(x);
    
    // first half:
    // 0: x: t; y: aboveOutside
    // 1: x: t; y: aboveOutside
    // 2: x: t-1; y: belowInside
    // 3: x: t-1; y: belowInside
    
    // second half:
    // 0: x: t; y: belowOutside 
    // 1: x: t; y: belowOutside
    // 2: x: t-1; y: aboveInside
    // 3: x: t-1; y: aboveInside
};

StringBowLine.prototype.jete = function() {
    
    this.bowLine = SCORE.compoundPathItems.add();
    
    //var lineLength = pythagoras(this.height, this.width); 
    var lineLength = this.width;
    var angle = slopeToAngle(this.slope); // this is perhaps not necessary?
    
    this.dynamics = this.info.dynamics;
    this.dynamicsInterp = new Interpolation(
        this.x0,
        this.dynamics[0],
        this.x1,
        this.dynamics[1],
        .5
    );
    this.yInterp = new Interpolation(
        this.x0,
        this.y0,
        this.x1,
        this.y1,
        this.exp
    );
    
    this.speed = this.info.speed;
    
    var box_width = 5;
    var amountBoxes = Math.round(lineLength/7*this.speed);;
    var amountGaps = amountBoxes - 1;
    var gap_space = lineLength - amountBoxes*box_width;
    var gap_width = gap_space/amountGaps;
    
    // iterate through each box
    for (var b = 0; b < amountBoxes; b ++) {
        
        var box = this.bowLine.pathItems.add();
        // box_width + (box-1)*gap_width
        
        // declare array of points
        var points = [];
        
        // iterate through each poin in box
        for (var p = 0; p < 4; p ++) {
            
            // point 1
            if (p == 0) {
                
                if (b == 0) {
                    
                    var x = this.x0/* + .5*box_width*/;
                    var y = this.y0 + this.dynamics[0];
                }
                else if (b > 0) {
                    
                    var x = this.x0 + b*box_width + b*gap_width;
                    var y = this.yInterp.point(x) + this.dynamicsInterp.point(x);
                };
            }
            // point 2
            else if (p == 1) {
                
                var x = this.x0 + (b+1)*box_width + b*gap_width;
                var y = this.yInterp.point(x) + this.dynamicsInterp.point(x);
            }
            // point 3
            else if (p == 2) {
                
                var x = this.x0 + (b+1)*box_width + b*gap_width;
                var y = this.yInterp.point(x) - this.dynamicsInterp.point(x);
            }
            // point 4
            else if (p == 3) {
                
                if (b == 0) {
                    
                    var x = this.x0/* + .5*box_width*/;
                    var y = this.yInterp.point(x) - this.dynamics[0];
                }
                else if (b > 0) {
                    
                    var x = this.x0 + b*box_width + b*gap_width;
                    var y = this.yInterp.point(x) - this.dynamicsInterp.point(x);
                };
            }
            
            // define current point
            var point = [x,y];
            
            // add point to array of points
            points.push(point);
        }
        
        box.setEntirePath(points);
        box.stroked = false;
        box.filled = true;
        box.fillColor = this.color();
        box.closed = true;
    };
};

StringBowLine.prototype.color = function() {
    
    var bowPositionColor = new BowPositionColor(this.bowPositions);
    
    var newGradient = bowPositionColor.gradient();

    return newGradient;
};