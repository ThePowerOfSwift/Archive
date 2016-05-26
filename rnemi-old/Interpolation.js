function Interpolation(x0, y0, x1, y1, exp) {
	
	// SOMETHING
	this.x0 = x0;
	this.y0 = y0;
	this.x1 = x1;
	this.y1 = y1;
	this.exp = exp;
}

Interpolation.prototype.point = function(x) {
	
	var y = ((this.y1 - this.y0)/Math.pow((this.x1 - this.x0), this.exp))* 
				Math.pow((x - this.x0), this.exp) + this.y0;
	
	return y;
};