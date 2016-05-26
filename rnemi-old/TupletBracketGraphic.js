﻿function TupletBracketGraphic(x, y, g, direction, amountBeams, group) {        this.x = x;    this.y = y;    this.g = g;    this.direction = direction;    this.amountBeams = amountBeams;    this.group = group;        this.width = 0.5 * this.g;    //this.padding = 0.382 * this.g;    //this.graphicAdjust = (0.5 * this.width) + this.padding;        this.beamWidth = (0.25 - (0.0275*this.amountBeams)) * this.g;    this.beam_displace = (1 + (0.35 * this.amountBeams)) * this.beamWidth;        this.stemWidth = 0.0618 * this.g;    this.stemLength = 1.382 * this.g;        this.outside = this.y + (this.direction * 0.5 * this.stemLength);    this.inside = this.y - (this.direction * 0.5 * this.stemLength);        this.color = gray[33];        // Declare group for graphic    this.tupletBracketGraphic = this.group.groupItems.add();        // Draw stem    this.stem();        // Draw beams    this.beams();}TupletBracketGraphic.prototype.stem = function() {        var stem = this.tupletBracketGraphic.pathItems.add();        stem.setEntirePath([        [            this.x - (this.direction * 0.5 * this.width),            this.inside        ],        [            this.x - (this.direction * 0.5 * this.width),            this.outside        ]    ]);        stem.strokeWidth = this.stemWidth;    stem.strokeColor = this.color;    stem.fillColor = this.color;};TupletBracketGraphic.prototype.beams = function() {        for (var b = 0; b < this.amountBeams; b ++) {                var beam = this.tupletBracketGraphic.pathItems.add();                beam.setEntirePath([            [                this.x - this.direction * (0.5 * (this.width + this.stemWidth)),                this.outside - (this.direction * (b * this.beam_displace))            ],            [                this.x + this.direction * (0.5 * this.width),                this.outside - (this.direction * (b * this.beam_displace))            ]        ]);        beam.strokeWidth = this.beamWidth;        beam.strokeColor = this.color;        beam.fillColor = this.color;    };};