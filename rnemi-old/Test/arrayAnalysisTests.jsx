﻿#include "../arrayMethods.js"var durList = [8,1,2,4,6,3,1,2];$.writeln("durList: " + durList);var cur = durList[3];var prev = durList[2];var dir = durList.direction(prev, cur);$.writeln("dir: " + dir);var Δ = durList.delta(prev, cur);$.writeln("delta: " + Δ);var maxΔ = durList.maxΔ();$.writeln("maxΔ: " + maxΔ);var indices = durList.maxΔIndices();$.writeln("indices: " + indices);var rep = durList.repetitionAtIndex(2);$.writeln("rep: " + rep);var dirSpans = durList.dirSpans();$.writeln("amountDirSpans: " + dirSpans.length);for (var d = 0; d < dirSpans.length; d ++) {    $.writeln("indices: " + dirSpans[d].indices)};//$.writeln("dirSpans: " + dirSpans);