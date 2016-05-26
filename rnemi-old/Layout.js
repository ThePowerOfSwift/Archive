function Layout() {

    // super class of View, Page, System, Measure
}

Layout.prototype.testRect = function(graphicalContext) {

    var rect = graphicalContext.pathItems.rectangle(
        this.top,  this.left, this.width, this.height
    );
    rect.strokeWidth = 0.5;
    rect.strokeColor = orange_dark;
    rect.fillColor = orange_light;
};