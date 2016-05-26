function SubdivisionGraphic(ParentObj, x, y) {
    
    t.w("SubdivisionGraphic");
    this.ParentObj = ParentObj;
    this.x = x || 400;
    this.y = y || 400;
    this.direction = this.ParentObj.stemDirection || 1;
    
    this.setGraphicalDimensions();
    this.draw();
}

SubdivisionGraphic.prototype.setGraphicalDimensions = function() {

    this.g = this.ParentObj.g || 5;;
    this.width = this.ParentObj.graphicWidth || 0.5 * this.g;

    this.amountBeams = subdToLevel(this.ParentObj.subdivision) || 3;
    this.beamWidth = (0.25 - (0.0275 * this.amountBeams)) * this.g;
    this.beamDisplace = (1 + (0.35 * this.amountBeams)) * this.beamWidth;
    
    this.stemWidth = 0.0618 * this.g;
    this.stemLength = 1.382 * this.g;
    
    this.outside = this.y + (this.direction * 0.5 * this.stemLength);
    this.inside = this.y - (this.direction * 0.5 * this.stemLength);
    
    this.color = gray[33];
    this.graphicalContext = this.ParentObj.graphicalContext.groupItems.add();
}

SubdivisionGraphic.prototype.getDimensions = function() {

    var sortedValsY = [this.inside,this.outside].numSort();
    var top = sortedValsY[1];
    var left = this.x - this.direction * (0.5 * (this.width + this.stemWidth));
    var right = this.x + this.direction * (0.5 * (this.width + this.stemwWidth));
    var bottom = sortedValsY[0];

    // return object with bounding rect
    this.dimensions = {
        "top": top,
        "left": left,
        "right": right,
        "bottom": bottom
    };
    return this.dimensions;
}

SubdivisionGraphic.prototype.draw = function() {

    // draw all components
    this.stem();
    this.beams();
}

SubdivisionGraphic.prototype.stem = function() {

    var x = this.x - (this.direction * 0.5 * this.width)
    var y0 = this.inside;
    var y1 = this.outside;
    var points = [[x, y0], [x, y1]];

    var stem = this.graphicalContext.pathItems.add();
    stem.setEntirePath(points);
    stem.strokeWidth = this.stemWidth;
    stem.strokeColor = this.color;
    stem.fillColor = this.color;
}

SubdivisionGraphic.prototype.beams = function() {

    for (var b = 0; b < this.amountBeams; b ++) {
        var x0 = this.x - this.direction * (0.5 * (this.width + this.stemWidth));
        var x1 = this.x + this.direction * (0.5 * (this.width + this.stemWidth));
        var y = this.outside - (this.direction * (b * this.beamDisplace));
        var points = [[x0, y],[x1, y]];

        var beam = this.graphicalContext.pathItems.add();
        beam.setEntirePath(points);
        beam.strokeWidth = this.beamWidth;
        beam.strokeColor = this.color;
        beam.fillColor = this.color;
    };
}