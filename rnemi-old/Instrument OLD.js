#include "BeamGroup.js"
#include "arrayMethods.js"

function Instrument(left, instr) {
	
	this.left = left - 15;
	this.instr = instr;
	
	this.rest_color = orange_dark;
	
	this.bracket_displacement = 7;
	this.bracketHeights = [];
	this.lineHeights = [];
	
	for (var graph in instr.graphs) {
		
		var curGraph = instr.graphs[graph];
		
		// Add all graph tops and bottoms to a list
		this.bracketHeights.push(curGraph.top + 10/*2*curGraph.g*/)
		this.bracketHeights.push(curGraph.bottom - 10/*2*curGraph.g*/);
		
		// Add all line heights and bottoms to a list
		this.lineHeights.push(curGraph.top)
		this.lineHeights.push(curGraph.bottom);
	};
	
	// Sort lists
	this.bracketHeights.numSort();
	this.lineHeights.numSort();
	
	// Establish beamGroupAltitude
	this.beamGroup_altitude = this.lineHeights[0] - 35; // MAKE RELATIVE!
	
	// Define bracket reference points
	this.bracket_top = this.bracketHeights[this.bracketHeights.length - 1];
	this.bracket_bottom = this.bracketHeights[0];
	
	// Define line reference points
	this.line_top = this.lineHeights[this.lineHeights.length - 1];
	this.line_bottom = this.lineHeights[0];
	
	// Draw bracket and line
	this.graphGroup_bracket();
	//this.graphGroup_line();
}

Instrument.prototype.graphGroup_bracket = function() {
	
	// Draw graphGroup bracket
	var bracket = GRAPH_ITEMS.pathItems.add();
	bracket.setEntirePath([
		[
			this.left - .382*this.bracket_displacement,
			this.bracket_top + .618*this.bracket_displacement
		],
		[
			this.left - this.bracket_displacement,
			this.bracket_top
		],
		[
			this.left - this.bracket_displacement,
			this.bracket_bottom
		],
		[
			this.left - .382*this.bracket_displacement,
			this.bracket_bottom - .618*this.bracket_displacement
		]
	]);
	bracket.strokeWidth = 1.5;
	bracket.strokeColor = gray[30];
	bracket.filled = false;
	
};

Instrument.prototype.graphGroup_line = function() {
	
	if (this.lineHeights.length > 2) {
		
		// Draw graphGroup_line
		var line = GRAPH_ITEMS.pathItems.add();
		line.setEntirePath([
			[this.left, this.line_top],
			[this.left, this.line_bottom]
		]);
		line.strokeWidth = 1.5;
		line.strokeColor = gray[10];
		line.filled = false;
	};
}

Instrument.prototype.beamGroup = function(curX, info) {
	
	// ADD NEW BEAM GROUP
	var beamGroup = new BeamGroup(curX, this.beamGroup_altitude, info);
};

Instrument.prototype.rest = function(curX, stemlet_length, curSubdivision) {
	
	// Call rests for all graphs in current Instrument
	for (var graph in this.instr.graphs) {
        
        var curGraph = this.instr.graphs[graph];
        curGraph.rest(curX);
	};
	
	// Draw restLine
	this.restLine(curX, stemlet_length, curSubdivision);
};

Instrument.prototype.restLine = function(curX, stemlet_length, curSubdivision) {
	
	var restBeam_strokeWidth = 2;
	var restBeam_length = 3.5;
	var restBeam_altitude = this.lineHeights[this.lineHeights.length - 1] + 2.5;
	var restBeam_displacement = 3/2*restBeam_strokeWidth;
	
	var dashedLine_top = this.lineHeights[this.lineHeights.length - 1] - 1.75;
	var dashedLine_bottom = this.beamGroup_altitude + stemlet_length + 1;
		
	// Draw restLine
	var dashedLine = BEAM_ITEMS.pathItems.add();
	dashedLine.stroked = true;
	dashedLine.strokeWidth = .5; // MAKE RELATIVE
	dashedLine.strokeColor = this.rest_color;
	dashedLine.strokeDashes = [.25*5]; // MAKE RELATIVE LATER
	dashedLine.filled = false;
	dashedLine.setEntirePath([
		[
			curX,
			dashedLine_top
		],
		[
			curX,
			dashedLine_bottom
		]
	]);
	
	// Draw restBeams
	for (var restSubd = 0; restSubd < curSubdivision + 1; restSubd ++) {
		
		var restBeam = BEAM_ITEMS.pathItems.add();
		restBeam.stroked = true;
		restBeam.strokeWidth = restBeam_strokeWidth;
		restBeam.filled = false;
		restBeam.strokeColor = this.rest_color;
		restBeam.setEntirePath([
			[
				curX - .5*restBeam_length,
				restBeam_altitude + restSubd*restBeam_displacement
			],
			[
				curX + .5*restBeam_length,
				restBeam_altitude + restSubd*restBeam_displacement
			]
		]);
	}
	
	var connectingLine_top = restBeam_altitude + 
		curSubdivision*restBeam_displacement + .5*restBeam_strokeWidth;

	var connectingLine_bottom = this.lineHeights[this.lineHeights.length - 1] - 
		.875;
	
	// Draw connectingLine
	var connectingLine = BEAM_ITEMS.pathItems.add();
	connectingLine.stroked = true;
	connectingLine.strokeColor = this.rest_color;
	connectingLine.strokeWidth = .5; // MAKE RELATIVE
	connectingLine.filled = false;
	connectingLine.setEntirePath([
		[
			curX,
			connectingLine_top
		],
		[
			curX, 
			connectingLine_bottom
		]
	]);
	
	
	
}

/*Instrument.prototype.event = function(curX, info) {
	
	if (info.instrumentType == "wind") {
		
		// DO WINDY THINGS
	}
	else if (info.instrumentType == "string") {
		
		// DO STRINGY THINGS
	};
		
	//this.instr.graphs.sounding.pitch(info.events)
};*/

Instrument.prototype.linePoints = function(curX) {
	
	for (var graph in this.instr.graphs) {
		
		var curGraph = this.instr.graphs[graph];
		curGraph.linePoints(curX);
	}
};

Instrument.prototype.lines = function(curX) {
	
	for (var graph in this.instr.graphs) {
		
		var curGraph = this.instr.graphs[graph];
		curGraph.lines();
	}
};

Instrument.prototype.barline = function(curX) {
	
	// Draw barline for from bottom of lineHeights to top of lineHeights
	var barline = new Barline(
		curX, 
		this.lineHeights[this.lineHeights.length - 1],
		this.lineHeights[0]
	);
	
	//this.linePoints(curX);
	//this.lines();
	//this.linePoints(curX);
}