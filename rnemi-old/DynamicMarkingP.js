function DynamicMarkingP(DynamicMarking, x, y) {
    
    this.DynamicMarking = DynamicMarking;
    this.graphicalContext = this.DynamicMarking.graphicalContext;
    this.y = this.DynamicMarking.y;
    this.x = x || 400;
    this.g = this.DynamicMarking.g || 5;
    this.color = this.DynamicMarking.color;
    this.strokeWidth = 0.75 * this.DynamicMarking.strokeWidth;
    this.serifLength = this.DynamicMarking.serifLength;

    this.stem();
    this.ellipse();
    this.serif();
}

DynamicMarkingP.prototype.stem = function() {
    
    var points = [
        [this.x - 1 * this.g, this.y + 0.65 * this.g],
        [this.x - 0.45 * this.g, this.y + 0.8 * this.g],
        [this.x - 1 * this.g, this.y - 1.8 * this.g]
    ];
    var stem = this.graphicalContext.pathItems.add();
    stem.setEntirePath(points);
    stem.strokeWidth = this.strokeWidth;
    stem.strokeColor = this.color;
    stem.filled = false;
    stem.strokeJoin = StrokeJoin.ROUNDENDJOIN;
}

DynamicMarkingP.prototype.serif = function() {

    var x0 = this.x - (1 * this.g) - (0.5 * this.serifLength);
    var x1 = this.x - (1 * this.g) + (0.5 * this.serifLength);
    var y = this.y - 1.8 * this.g;
    var serif = this.graphicalContext.pathItems.add();
    serif.setEntirePath([[x0, y],[x1, y]]);
    serif.strokeWidth = this.strokeWidth;
    serif.strokeColor = this.color;
    serif.filled = false;
}

DynamicMarkingP.prototype.ellipse = function() {

    var height = 1.1 * this.g;
    var width = 1.382 * height;
    var top = this.y + 0.55 * this.g;
    var left = this.x - 0.5 * width;
    var ellipse = this.graphicalContext.pathItems.ellipse(
        top, left, width, height
    );
    ellipse.rotate(68);
    ellipse.strokeWidth = this.strokeWidth;
    ellipse.strokeColor = this.color;
    ellipse.fillColor = white;;
};

