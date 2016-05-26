﻿#include "../colors.js"function RhythmTestStaff(altitude, g) {		this.top = altitude;	this.bottom = altitude;	this.g = g;	curGraph = this;	this.declareLine();}RhythmTestStaff.prototype.declareLine = function() {	this.line = testDoc.pathItems.add();	this.line.strokeWidth = 0.125;	this.line.strokeColor = gray[50];	this.line.filled = false;}RhythmTestStaff.prototype.linePoint = function(x) {	var point = this.line.pathPoints.add();	point.anchor = [x, this.top];	point.leftDirection = point.anchor;	point.rightDirection = point.anchor;}RhythmTestStaff.prototype.event = function(x) {	var height = 1.618 * this.g;	var width = 0.618 * this.g;	var rectangle = testDoc.pathItems.rectangle(		this.top + 0.5 * height,		x - 0.5 * width,		width,		height	);	rectangle.stroked = false;	rectangle.fillColor = tupletColor[curBeamGroup.curTupletDepth].darkColor;	this.linePoint(x);}RhythmTestStaff.prototype.rest = function(x) {	this.linePoint(x);	this.declareLine();}