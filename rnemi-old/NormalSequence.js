//#include "t.js"#include "arrayMethods.js"#include "Interpolation.js"function NormalSequence(    min, max, muMean, sigmaMin, sigmaMax, dirStrength,     amountRepetition, resolution, isExponential) {    // t.w("NormalSequence");    this.min = min || 1;    this.max = max || 8;    this.muMean = muMean || 4;    // reorganize to inject with initial val    this.mean = Math.random()*(this.max - this.min) + this.min;    //this.mean = this.muMean;    this.sigmaMin = sigmaMin || 0.25;    this.sigmaMax = sigmaMax || 1;    this.dirStrength = dirStrength || 0.1;    this.amountRepetition = amountRepetition || 0;    this.resolution = resolution || 1;    if (isExponential === undefined) { this.isExponential = true; };    else { this.isExponential = isExponential; };    this.sequence = [];    this.dirSpans = [];    this.initializeInterpolations();    this.callInterpolationsAtPoint(0);}NormalSequence.prototype.initializeInterpolations = function() {    this.interpParams = [        "min", "max", "mean",         "dirStrength", "sigmaMin", "sigmaMax",         "amountRepetition", "resolution"    ];    for (var p = 0; p < this.interpParams.length; p ++) {        var param = this.interpParams[p];        var interpName = param + "_interp";        if (typeof this[param] === "number") {            // Create static interpolation that will return same val regardless            this[interpName] = new Interpolation(                0, this[param], 1, this[param], 1            );        }        else if (typeof this[param] === "object") {            // Create dynamic interpolation with values given            this[interpName] = new Interpolation(                0, this[param][0], 1, this[param][1], this[param][2]            );        };    };};NormalSequence.prototype.callInterpolationsAtPoint = function(x) {    for (var p = 0; p < this.interpParams.length; p ++) {        var param = this.interpParams[p];        var interpName = param + "_interp";        this[param] = this[interpName].point(x);        if (param === "resolution") {            this[param] = roundBinary(this[param]);        };    };};NormalSequence.prototype.establishCurrentPosition = function() {    if (this.sequence.length === 0) {        return 0;     }    else {        if (this.byWhat === "bySum") {            if (this.byWhatVal.length === 1) {                var x = this.sequence.sum() / this.byWhatVal[0];                return x;            }            else {                // if bySum: a little prediction / estimation made for interpolation                // not very clean                var sumSum = 0;                for (var s = 0; s < this.byWhatVal.length; s ++) {                    sumSum += this.byWhatVal[s];                };                var meanSum = sumSum / this.byWhatVal.length;                var x = (this.sequence.length * this.mean) / meanSum;                return x;            };            }        else if (this.byWhat === "byAmount") {            var totalAmount = this.byWhatVal;            var curAmount = this.sequence.length;            var x = curAmount / totalAmount;            return x;        }        else { return 0; };    };};NormalSequence.prototype.wholeSeq = function(byWhat, val) {    this.byWhat = byWhat;    this.byWhatVal = val;    // If byWhat === bySum; val is array of vals: length: 1 - n;    // If byWhat === byAmount; val is pos num    if (byWhat === "bySum") {          // val comes in as array of possible sums        // sort this from low to high        val.numSort();        var maxVal = val.last();        while (this.sequence.sum() < maxVal) {            var newNum = this.singleNum();                                         this.sequence.push(newNum);            if (this.sequence.sum() > maxVal) {                this.sequence.length = 0;                this.callInterpolationsAtPoint(0);            }            else {                if (val.contains(this.sequence.sum())) {                    if (this.sequence.length > 0) {                        return this.sequence;                    };                };            };        };    }    else if (byWhat === "byAmount") {        for (var num = 0; num < val; num ++) {            var newNum = this.singleNum();            this.sequence.push(newNum);        };        return this.sequence;    };};NormalSequence.prototype.singleNum = function() {    // t.w("singleNum ============")    // t.w("this.min: " + this.min);    // t.w("this.max: " + this.max);    // t.w("this.mean: " + this.mean);    // t.w("singleNum: this.resolution: " + this.resolution);    // t.w("this.amountRepetition: " + this.amountRepetition);    if (this.sequence.length === 0) {        this.sigma = this.meanToSigma(this.mean);        //// t.w("singleNum.sigma: " + this.sigma);        this.sigma = 1;    };        var x1, x2, rad;    // GENERATE A NEW NUMBER    do {        do {            x1 = 2 * Math.random() - 1;            x2 = 2 * Math.random() - 1;            rad = x1 * x1 + x2 * x2;        }         while (rad >= 1 || rad === 0);        var c = Math.sqrt(-2 * Math.log(rad) / rad);        var newNum = ((x1 * c) * this.sigma) + this.mean;                // t.w("singleNum: resolution: " + this.resolution);        newNum = Math.round(newNum * this.resolution) / this.resolution;        // TEST IF GENERATED VALUE IS ACCEPTABLE GIVEN CONSTRAINTS        var acceptable = true;                // IF WITHIN BOUNDS        if (newNum < this.min || newNum > this.max) acceptable = false;                    // IF NOT TOO MANY REPETITIONS        if (this.sequence.length > this.amountRepetition) {            var repetitionMatch = true;            for (var r = 1; r <= this.amountRepetition + 1; r ++) {                if (newNum !== this.sequence[this.sequence.length - r]) {                    repetitionMatch = false;                    break;                };            };        }        else {            repetitionMatch = false;        };                // If the last r numbers are of the same value, must choose another newNum        if (repetitionMatch === true) acceptable = false;        if (this.isExponential === true) {                        // Initiate exponential list            var expList = [];            for (var exponent = -1; exponent < 10; exponent ++) {                expList.push(2*Math.pow(2,exponent));                expList.push(3*Math.pow(2,exponent));            }            if (expList.contains(newNum) === false) acceptable = false;        };        // If newNum has passed all of the tests to this point        if (acceptable === true) {            if (this.sequence.length === 0) {                if (newNum > .5*this.range + this.min) { this.dir = -1; };                else { this.dir = 1; };              }            else if (this.sequence.length > 0) {                if (newNum < this.sequence.last()) { this.dir = -1; }                else if (newNum > this.sequence.last()) { this.dir = 1; };            };            // Establish position within sequence for interpolations            var x = this.establishCurrentPosition();            this.callInterpolationsAtPoint(x);            // Define characteristics for next choice            this.mean = newNum * (1 + (this.dir * this.dirStrength));            this.sigma = this.meanToSigma(newNum);                        return newNum;        };    }    // KEEP WITHIN DESIRED BOUNDS (I ASSUME THESE CAN BE FLEXIBLE)    while (acceptable === false)}NormalSequence.prototype.meanToSigma = function(curVal) {    var sigmaRange = this.sigmaMax - this.sigmaMin;    var muMin = this.min;    var muMax = this.max;    var muMean = this.muMean;    var curMu = curVal;    // Find greater difference between extremes and mean    var muRange;    if ((muMean - muMin) >= (muMax - muMean)) muRange = muMean - muMin;    else muRange = muMax - muMean;    muRange *= 2;    var verticalScale = (4 * sigmaRange) / (Math.pow(muRange, 2));    var horizontalTranslation = Math.pow((curMu - muMean),2);    var verticalTranslation = this.sigmaMin;    // Actual calculation    var sigma = (verticalScale * horizontalTranslation) + verticalTranslation;    sigma *= (this.max - this.min);    return sigma;};NormalSequence.prototype.selfAnalyze = function() {    this.greatestDelta = this.findGreatestDelta().delta;    this.greatestDeltaIndex = this.findGreatestDelta().index;    // Find max at index    this.maxAtIndex = {};    this.minAtIndex = {};    for (var i = 0; i < this.sequence.length; i ++) {        var curVal = this.sequence[i];        if (! this.maxAtIndex.max || curVal > this.maxAtIndex.max) {            this.maxAtIndex.max = curVal;            this.maxAtIndex.index = i;        };    };    this.createDirSpans();    // Check for overlap and bounding repetition    for (var d = 0; d < this.dirSpans.length; d ++) {        var curDirSpan = this.dirSpans[d];        if (curDirSpan.edgeRepetition) {            //// t.w("edgeRepetition.begin: " + curDirSpan.edgeRepetition.begin);            //// t.w("edgeRepetition.end: " + curDirSpan.edgeRepetition.end);        }        if (curDirSpan.overlap) {            //// t.w("OVERLAP.begin: " + curDirSpan.overlap.begin);            //// t.w("OVERLAP.end: " + curDirSpan.overlap.end);        };    };    //// t.w("greatestDelta: " + this.greatestDelta);}NormalSequence.prototype.createDirSpans = function() {    // THIS IS TOTALLY FUCKED; ANALYTICS USELESS CURRENTLY?    // Once in a while, indices are correct, but actual sequence incorrect,    // therefore all analytics on these durations are useless    this.dirSpans = [];    for (var i = 2; i < this.sequence.length; i ++) {        var curDir = this.getInfoAtIndex(i).direction;        var prevDir = this.getInfoAtIndex(i - 1).direction;        if (            this.dirSpans.length > 0 &&            curDir === prevDir &&            curDir === this.dirSpans.last().direction &&            i === this.dirSpans.last().indices[1] + 1        ) {            // extend current dirSpan to current index            this.dirSpans.last().indices[1] = i;        }        else if (curDir === prevDir) {            // create new dirSpan            var dirSpan = {};            dirSpan.direction = curDir;            dirSpan.indices = [ (i-2), i ];            this.dirSpans.push(dirSpan);        };       /* for (var d = 0; d < this.dirSpans.length; d ++) {            var curDirSpan = this.dirSpans[d];            var curSequence = curDirSpan.sequence;            curDirSpan.max = curSequence.max();            curDirSpan.min = curSequence.min();        };*/        // Check for overlaps and bounding repetitions        /*this.dirSpanOverlaps = [];        if (this.dirSpans.length > 1) {            for (var d = 0; d < this.dirSpans.length - 1; d ++) {                var curDirSpan = this.dirSpans[d];                var curIndices = curDirSpan.indices;                var curBeginIndex = curDirSpan.indices[0];                var curEndIndex = curDirSpan.indices[1];                var nextDirSpan = this.dirSpans[d + 1];                var nextIndices = nextDirSpan.indices;                if (curIndices[1] === nextIndices[0]) {                    curDirSpan.overlap = curDirSpan.overlap || {};                    curDirSpan.overlap.end = true;                    nextDirSpan.overlap = nextDirSpan.overlap || {};                    nextDirSpan.overlap.begin = true;                };                // Check for bounding repetitions                if (this.getInfoAtIndex(curBeginIndex).repetition > 0) {                    curDirSpan.edgeRepetition = curDirSpan.edgeRepetition || {};                    curDirSpan.edgeRepetition.begin = true;                }                if (this.getInfoAtIndex(curEndIndex + 1).repetition > 0) {                    curDirSpan.edgeRepetition = curDirSpan.edgeRepetition || {};                    curDirSpan.edgeRepetition.end = true;                };            };        };*/        // Check for beginning or ending with repeating value    };    for (var d = 0; d < this.dirSpans.length; d ++) {        var dirSpan = this.dirSpans[d];        dirSpan.sequence = [];        var start = dirSpan.indices[0];        var end = dirSpan.indices[1];        for (var i = start; i <= end; i ++) {            dirSpan.sequence.push(this.sequence[i]);        };    };};NormalSequence.prototype.getInfoAtIndex = function(index) {    // Takes in values between 1 and this.sequence.length - 1    var cur = this.sequence[index];    var prev = this.sequence[index - 1];    var delta = this.deltaVal(cur, prev);    var direction = this.directionVal(cur, prev);    var repetition = this.countRepetitionAtIndex(index);    return {        "delta": delta,        "direction": direction,        "repetition": repetition    };};NormalSequence.prototype.findGreatestDelta = function() {    var greatestDelta;    var index;    for (var i = 0; i < this.sequence.length; i ++) {        var curDelta = this.getInfoAtIndex(i).delta;        if (!greatestDelta || Math.abs(curDelta) > Math.abs(greatestDelta)) {            greatestDelta = curDelta;            index = i;        };    };    return {        "delta": greatestDelta,        "index": index    };}NormalSequence.prototype.deltaVal = function(cur, prev) {    var vals = [cur,prev].numSort();    var delta = (vals[1] / vals[0]) - 1;    if (cur < prev) delta *= -1;    return delta;};NormalSequence.prototype.directionVal = function(cur, prev) {    var direction;    if (cur > prev) direction = 1;    else if (cur < prev) direction = -1;    else direction = 0;    return direction;};NormalSequence.prototype.countRepetitionAtIndex = function(index) {    var repetitionCount = 0;    for (var i = index - 1; i >= 0; i --) {        if (this.sequence[index] === this.sequence[i]) {            repetitionCount ++;        }        else {            return repetitionCount;        };      };    return repetitionCount;};