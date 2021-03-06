//
//  PlotView.swift
//  Plot
//
//  Created by James Bean on 1/10/17.
//
//

import GraphicsTools

/// Graphical representation of information.
///
/// The horizontal and vertical positioning of information if stratified into two steps:
/// - `(Vertical | Horizontal) Coordinate` systems: 
/// Abstract model of a coordinate system
/// that may be implemented in any number of ways. For example, a `Staff` may model the 
/// abstract position of `SpelledPitch` values on a given staff-line or in a given staff-space.
/// A string tablature system may have pre-defined positions which are irregularly placed.
///
/// - `Position`:
/// Concrete value for positioning a given musical element within a `PlotView`.
///
/// The graphical information is stratified into two layers: `structure` and `information`.
/// The `structure` layer may contain graphical elements like lines and axes. The `information`
/// layer will contain graphical representations of the actualy musical information.
///
/// Each of the graphical layers has its own renderer which can be define explicitly for any
/// type of musical information.
public protocol PlotView {
    
    // MARK: - Associated Types
    
    // MARK: Model
    
    /// The information that will be rendered onto a `PlotView`.
    associatedtype Model: PlotModel
    
    // MARK: Abstract positioning of entities
    
    /// Type that converts a given type of musical element to `AbstractVerticalPosition`.
    associatedtype VerticalAxis: Axis
    
    /// Type that converts a given type of musical element to `AbstractHorizontalPosition`.
    associatedtype HorizontalAxis: Axis
    
    /// Type that describes the abstract vertical coordinate system of a `PlotView`.
    ///
    /// For example, `Staff` implements this as `StaffSlot`.
    associatedtype VerticalCoordinate

    /// Type that describes the abstract horizontal coordinate system of a `PlotView`.
    associatedtype HorizontalCoordinate

    // MARK: Concrete positioning of entities
    
    /// Native numerical type of `GraphicalContext`. Probably a floating-point type.
    associatedtype Position
    
    // MARK: Graphics
    
    /// Stores an abstract model of lines and axes, tailored for the specific `PlotView`
    /// implementation.
    ///
    /// Will likely render lines and the ax(is|es).
    associatedtype StructureRenderer: Renderer
    
    /// Stores an abstract model of information, tailorded for the specific `PlotView`
    /// implementation.
    associatedtype InformationRenderer: Renderer
    
    /// The type of graphical context onto which this `PlotView` will be rendered.
    associatedtype GraphicalContext
    
    // MARK: - Instance Properties
    
    // MARK: Model
    
    /// The information that will be rendered onto a `PlotView`.
    var model: Model { get }
    
    // MARK: Positioning of entities
    
    /// Determines the way that information is mapped onto the vertical axis.
    var verticalAxis: VerticalAxis { get }
    
    /// Determines the way that information is mapped onto the horizontal axis.
    var horizontalAxis: HorizontalAxis { get }
    
    /// Transforms an abstract vertical coordinate into a concrete vertical position.
    var concreteVerticalPosition: (VerticalCoordinate) -> Position { get }
    
    /// Transforms an abstract horizontal coordinate into a concrete horizontal position.
    var concreteHorizontalPosition: (HorizontalCoordinate) -> Position { get }

    // MARK: Graphics
    
    /// Concrete layer containing the structural elements of a `PlotView`
    var structure: GraphicalContext { get }
    
    /// Concrete layer containing the informational elements of a `PlotView`.
    var information: GraphicalContext { get }
    
    // MARK: Renderers
    
    /// Renders the information onto the `information` `Layer`, given configuration.
    var informationRenderer: InformationRenderer { get }
    
    /// Renders the structure onto the `structure` `Layer`, given configuration.
    var structureRenderer: StructureRenderer { get }
}
