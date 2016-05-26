#include "Staff.js"

function Graph(Instrument) {
    
    this.Instrument = Instrument;
    this.measureList = this.Instrument.measureList;
    this.measureRange = this.Instrument.measureRange;
    this.performerID = this.Instrument.performerID;
    this.g = this.Instrument.g;

    this.setDimensions();
}

Graph.prototype.setDimensions = function() {

    this.graphTop = 0; // Default at 0 for height calculation
    this.graphHeight = 4 * this.g; // Make flexible
    this.graphBottom = this.graphTop - this.graphHeight;
    this.setPitchAltitudes();
};

Graph.prototype.getHeightForLayout = function() {

    this.height = this.yMax - this.yMin;
    return this.height;
};

Graph.prototype.setPitchAltitudes = function() {

    // scan through this.measureList in this.measureRange
    // for testing, set yMax and yMin to graph.top, graph.bottom;
    // retun height
    /*var randHeightTop = Math.random()*40;
    var randHeightBottom = Math.random()*40;

    this.graphMiddle = (this.graphTop + this.graphBottom) / 2;
    var maxNoteheadY = this.graphMiddle + randHeightTop;
    var minNoteheadY = this.graphMiddle - randHeightBottom;*/
    this.yMax = this.graphTop;
    this.yMin = this.graphBottom;
}

Graph.prototype.draw = function(graphicalContext) {

    this.graphicalContext = graphicalContext.layers.add();
    this.graphicalContext.name = "graphID";
    var staff = new Staff(this.top, this.left, this.g);
    staff.draw(this.graphicalContext);
    staff.linePoints(this.left + this.width);
    //this.testRect();
}

Graph.prototype.testRect = function() {

    this.width = this.Instrument.Performer.System.width;
    this.height = this.graphTop - this.graphBottom;
    this.graphicalContext = this.Instrument.Performer.System.graphicalContext;
    /*var rect = this.graphicalContext.pathItems.rectangle(
        this.top, this.left, this.width, this.height
    );
    rect.strokeWidth = 0.618;
    rect.strokeColor = orange_dark;
    rect.filled = false;
    */

    
}