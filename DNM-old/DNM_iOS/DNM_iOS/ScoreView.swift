//
//  ScoreView.swift
//  DNM_iOS
//
//  Created by James Bean on 11/30/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

/** 
Single view of the score model 
(can be either a full score (.Omni viewer), or a single part (.Performer viewer))
*/
public class ScoreView: UIView, ComponentSelectorTableViewHeaderButtonDelegate {
    
    /// The ScoreViewModel for this ScoreView (contains the ScoreModel, as well as ComponentFilters)
    public var viewModel: ScoreViewModel!
    
    // MARK: - PageViews
    
    /// All PageViews
    public var pageViews: [PageView] = []
    
    /// Current PageView
    public var currentPageView: PageView?

    /// Index of current PageView
    public var currentPageIndex: Int? { return getCurrentPageIndex() }
    
    // MARK: - Systems
    
    /// All SystemLayers that are contained within this ScoreView, placed on PageLayers
    public var systemLayers: [SystemLayer] = []
    
    /// All SystemViews that are contained within this ScoreView, placed on PageViews
    public var systemViews: [SystemView] = []
    
    // MARK: - ComponentSelectorTableview
 
    // TODO: refactor this out of here
    /// TableView for selecting what musical information to show for which DurationIntervals
    public var componentSelectorTableView: UITableView!
    private var componentSelectorDragOverlay: UIView!
    private var componentSelectorTableViewCellTouched: ComponentSelectorTableViewCell?
    private var componentSelectorTableViewHeaderButtonTouched: ComponentSelectorTableViewHeaderButton?
    
    /// Data for componentSelectorTableView
    public var componentSelectorTableViewModels: [
        (ComponentSelectorTableViewHeaderModel, [ComponentSelectorTableViewCellModel])
    ] = []
    
    private var currentComponentSpan: ComponentFilter?
    
    let defaultStaffHeight: StaffSpaceHeight = 10
    let defaultBeatWidth: BeatWidth = 110
    
    /**
    Create a ScoreView with an identifier and scoreModel

    - parameter identifier: String with identifier of PerformerStratum ViewerTypeID
    - parameter scoreModel: ScoreModel

    - returns: ScoreView
    */
    public init(viewModel: ScoreViewModel) {
        super.init(frame: CGRectZero)
        self.viewModel = viewModel
        build()
    }
    
    public override init(frame: CGRect) { super.init(frame: frame) }
    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

    // MARK: - Page Navigation
    
    /**
    Show the page at the specified index
    
    - parameter index: Index of page to show
    */
    public func goToPageAtIndex(index: Int) {
        if index >= 0 && index < pageViews.count {
            removeCurrentPageView()
            let pageView = pageViews[index]
            currentPageView = pageView
            insertSubview(pageView, atIndex: 0)
        }
    }
    
    /**
    Show the previous page, if possible
    */
    public func goToPreviousPage() {
        if let currentPageIndex = currentPageIndex { goToPageAtIndex(currentPageIndex - 1) }
    }
    
    /**
    Show the next page, if possible
    */
    public func goToNextPage() {
        if let currentPageIndex = currentPageIndex { goToPageAtIndex(currentPageIndex + 1) }
    }
    
    /**
    Show the first page
    */
    public func goToFirstPage() {
        goToPageAtIndex(0)
    }
    
    /**
    Show the last page
    */
    public func goToLastPage() {
        goToPageAtIndex(pageViews.count - 1)
    }
    
    public func goToPageView(pageView: PageView) {
        removeCurrentPageView()
        insertSubview(pageView, atIndex: 0)
        currentPageView = pageView
    }
    
    public func goToDuration(duration: Duration) {
        if let systemView = systemViewContaining(duration) {
            if let pageView = pageViewContaining(systemView) { goToPageView(pageView) }
        }
    }
    
    public func systemViewContaining(duration: Duration) -> SystemView? {
        for systemView in systemViews {
            if systemView.systemLayer.viewModel.model.scoreModel.contains(duration) {
                return systemView
            }
        }
        return nil
    }
    
    public func pageViewContaining(systemView: SystemView) -> PageView? {
        for pageView in pageViews {
            if pageView.systemViews.containsObject(systemView) {
                return pageView
            }
        }
        return nil
    }
    
    // MARK: - ComponentSelectorTableView
    
    public func didPressHeaderButton(button: ComponentSelectorTableViewHeaderButton) {
        let performerID = button.model.performerID
        if let section = sectionFor(performerID) {
            switch button.model.state {
            case .On: unmuteCellsInSection(section)
            case .Off: muteCellsInSection(section)
            case .MultipleValues: break
            }
        }
    }
    
    private func sectionFor(performerID: PerformerID) -> Int? {
        for (s, section) in componentSelectorTableViewModels.enumerate() {
            if section.0.performerID == performerID { return s }
        }
        return nil
    }
    
    /**
    Hide ComponentSelectorTableView if it is currently showing; show if it is hidden
    */
    public func switchComponentSelectorTableView() {
        switch componentSelectorTableView.superview {
        case nil: showComponentSelectorTableView()
        default: hideComponentSelectorTableView()
        }
    }
    
    /**
    Show ComponentSelectorTableView
    */
    public func showComponentSelectorTableView() {
        componentSelectorTableView.resizeToFitContents()

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.1)
        
        let newFrame = componentSelectorTableView.frame
        componentSelectorTableView.layer.position.x = 0.5 * newFrame.width
        componentSelectorDragOverlay.frame = componentSelectorTableView.bounds

        UIView.commitAnimations()
    }
    
    /**
    Hide ComponentSelectorTableView
    */
    public func hideComponentSelectorTableView() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.25)
        var newFrame = componentSelectorTableView.frame
        newFrame.origin.x = -newFrame.width * 2
        componentSelectorTableView.frame = newFrame
        componentSelectorDragOverlay.frame = newFrame
        UIView.commitAnimations()
    }
    
    // MARK: - ComponentFilters
    
    /**
    Begin adding ComponentTypeAndStateByPerformerID data to ComponentFilter with DurationInterval
    
    - parameter durationInterval: DurationInterval for new ComponentFilter
    */
    public func beginComposingComponentSpanWith(durationInterval: DurationInterval) {
        if durationInterval.duration > DurationZero {
            currentComponentSpan = ComponentFilter(durationInterval: durationInterval)
            prepareComponentSelectorTableViewFor(durationInterval)
            showComponentSelectorTableView()
        }
    }
    
    public func commitComponentSpanInProcess() {
        if var componentFilter = currentComponentSpan {
            hideComponentSelectorTableView() // hide, and then rebuild
            componentFilter = composeComponentSpan(componentFilter)

            
            // refactor: wrap
            pageViews.forEach { $0.clearSelectionRectangles() }
            updateScoreViewModelWith(componentFilter)
            currentComponentSpan = nil
        }
    }
    
    private func composeComponentSpan(componentFilter: ComponentFilter) -> ComponentFilter {
        let componentSpanComposer = ComponentSpanComposer(componentFilter: componentFilter)
        return componentSpanComposer.composeWith(componentSelectorTableViewModels)
    }

    // separate out scoreviewmodel and scoreview updating
    private func updateScoreViewModelWith(componentFilter: ComponentFilter) {
        viewModel.addComponentFilter(componentFilter)
        updateSystemLayerViewModelsWithComponentSpan(componentFilter)
        reflowSystems()
        if let componentFilter = currentComponentSpan {
            goToDuration(componentFilter.durationInterval.startDuration)
        }
    }
    
    private func updateSystemLayerViewModelsWithComponentSpan(componentFilter: ComponentFilter) {
        let overlappedSystemLayers = systemLayersOverlappedBy(componentFilter.durationInterval)
        overlappedSystemLayers.forEach {
            let componentFilters = viewModel.componentFilters.componentFiltersIn(
                $0.viewModel.model.scoreModel.durationInterval
            )
            $0.updateViewWithComponentSpans(componentFilters)
        }
    }
    
    // DEPRECATE ONCE componentTypeShown is - adapting ComponentFilter to ComponentTypesShownByID
    private func componentTypesShownWithIDFromComponentSpan(componentFilter: ComponentFilter)
        -> [String: [String]]
    {
        var componentTypesShownByID: [String: [String]] = [:]
        for (performerID, stateByComponentType) in componentFilter.componentTypeModel {
            for (componentType, state) in stateByComponentType {
                switch state {
                case .Show:
                    // ensure key at performerID val
                    if componentTypesShownByID[performerID] == nil {
                        componentTypesShownByID[performerID] = []
                    }
                    componentTypesShownByID[performerID]!.append(componentType)
                    
                case .Hide: break // nothing
                }
            }
        }
        return componentTypesShownByID
    }
    
    // find more generic solution to this
    private func systemLayersOverlappedBy(durationInterval: DurationInterval) -> [SystemLayer] {
        var start: Int?
        var stop: Int?
        
        // wrap
        for (s, systemLayer) in systemLayers.enumerate() {
            

            if systemLayer.viewModel.model.durationInterval.contains(
                durationInterval.startDuration
            )
            {
                start = s
                break
            }
        }
        
        // wrap
        for (s, systemLayer) in systemLayers.enumerate() {
            if systemLayer.viewModel.model.durationInterval.contains(
                durationInterval.stopDuration
            )
            {
                stop = s
                break
            }
        }

        if let start = start, stop = stop { return Array(systemLayers[start...stop]) }
        else { return [] }
    }
    
    private func prepareComponentSelectorTableViewFor(durationInterval: DurationInterval) {
        let model = modelForComponentSpansOverlappedBy(durationInterval)
        prepareComponentSelectorTableViewModel(model)
    }
    
    private func modelForComponentSpansOverlappedBy(durationInterval: DurationInterval)
        -> ComponentTypeMultipleStateModel
    {
        let overlappedSpans = componentSpansOverlappedBy(durationInterval)
        return overlappedSpans.componentTypeMultipleStateModel
    }

    private func componentSpansOverlappedBy(durationInterval: DurationInterval)
        -> ComponentFilters
    {
        let componentFilters = viewModel.componentFilters
        return componentFilters.componentFiltersOverlappedByDurationInterval(durationInterval)
    }
    
    private func prepareComponentSelectorTableViewModel(
        multipleStateModel: ComponentTypeMultipleStateModel
    )
    {
        var componentSelectorTableViewSectionModels: [
            (ComponentSelectorTableViewHeaderModel, [ComponentSelectorTableViewCellModel])
        ] = []
        
        // wrap up
        for (performerID, statesByComponentType) in multipleStateModel {

            var headerModel: ComponentSelectorTableViewHeaderModel?
            var cellModels: [ComponentSelectorTableViewCellModel] = []
            
            // wrap up
            for (componentType, states) in statesByComponentType {

                // check whether this info belongs to the current viewer
                var belongsToCurrentViewer: Bool {
                    return performerID == viewModel.viewerProfile.viewer.identifier
                }
                
                switch componentType {
                case "performer":
                    headerModel = ComponentSelectorTableViewHeaderModel(
                        performerID: performerID,
                        states: states,
                        belongsToCurrentViewer: belongsToCurrentViewer
                    )
                default:
                    let cellModel = ComponentSelectorTableViewCellModel(
                        componentType: componentType,
                        states: states,
                        belongsToCurrentViewer: belongsToCurrentViewer
                    )
                    cellModels.append(cellModel)
                }
            }
            
            // if valid headerModel, add section model to array
            if let headerModel = headerModel {
                let sectionModel = (headerModel, cellModels)
                componentSelectorTableViewSectionModels.append(sectionModel)
            }
        }
        self.componentSelectorTableViewModels = componentSelectorTableViewSectionModels
        setDefaultValuesForHeaderModels()
        componentSelectorTableView.reloadData()
    }
    
    private func setDefaultValuesForHeaderModels() {
        if viewModel.viewerProfile.viewer == ViewerOmni {
            for section in 0..<componentSelectorTableViewModels.count {
                componentSelectorTableViewModels[section].0.state = .On
                unmuteCellsInSection(section)
            }
        }
    }
    
    // MARK: - Build
    
    /**
    Build this ScoreView
    */
    public func build() {
        setFrame()
        manageSystems()
        managePages()
        positionSystemUIViews()
        setupComponentSelectorTableView()
    }
    
    private func managePages() {
        let pageViews = makePageViewsWithSystemLayers(systemLayers)
        self.pageViews = pageViews
        goToFirstPage()
    }
    
    private func manageSystems() {
        let systems = makeSystems()
        systemLayers = makeSystemLayersWithSystems(systems)
        createSystemUIViewsForSystemLayers(systemLayers)
    }
    
    public func reflowSystems() {
        pageViews.forEach { $0.removeFromSuperview() }
        pageViews = []
        self.pageViews = makePageViewsWithSystemLayers(systemLayers)
        goToFirstPage()
        positionSystemUIViews()
    }
    
    private func setupComponentSelectorTableView() {
        componentSelectorTableView = UITableView(
            frame: CGRect(x: 0, y: 0, width: 125, height: 400)
        )
        componentSelectorTableView.frame.origin.x = -2 * componentSelectorTableView.frame.width
        componentSelectorTableView.delegate = self
        componentSelectorTableView.dataSource = self
        componentSelectorTableView.scrollEnabled = false
        componentSelectorTableView.allowsMultipleSelection = true
        setupComponentSelectorDragOverlay()
        
        componentSelectorTableView.addSubview(componentSelectorDragOverlay)
        addSubview(componentSelectorTableView)
    }
    
    private func setupComponentSelectorDragOverlay() {
        componentSelectorDragOverlay = UIView(frame: componentSelectorTableView.frame)
        componentSelectorDragOverlay.backgroundColor = UIColor.clearColor()
        
        componentSelectorDragOverlay.addGestureRecognizer(
            UIPanGestureRecognizer(
                target: self,
                action: "didDragOverComponentSelectorTableView:"
            )
        )
        
        componentSelectorDragOverlay.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: "didTapComponentSelectorTableView:"
            )
        )
        componentSelectorDragOverlay.canBecomeFirstResponder()
    }
    
    public func didTapComponentSelectorTableView(gestureRecognizer: UITapGestureRecognizer) {
        let touchedPoint = gestureRecognizer.locationInView(componentSelectorTableView)
        if !hitHeaderViewButtonWithPoint(touchedPoint) {
            if !hitCellWithPoint(touchedPoint) {
                hitHeaderViewButtonForSection0()
            }
        }
        commitComponentSpanInProcess()
    }
    
    private func hitHeaderViewButtonForSection0() -> Bool {
        if let section0HeaderView = componentSelectorTableView.headerViewForSection(0) {
            if let button = headerButtonForHeaderView(section0HeaderView) {
                button.pressed()
                return true
            }
            return false
        }
        return false
    }

    
    public func didDragOverComponentSelectorTableView(gestureRecognizer: UIPanGestureRecognizer)
    {
        let touchedPoint = gestureRecognizer.locationInView(componentSelectorTableView)
        dragCellWithPoint(touchedPoint)
        if gestureRecognizer.state == .Ended {
            commitComponentSpanInProcess()
        }
    }
    
    private func dragCellWithPoint(point: CGPoint) -> Bool {
        if let cell = cellWithPoint(point) {
            if cell !== componentSelectorTableViewCellTouched {
                cell.goToNextState()
                componentSelectorTableViewCellTouched = cell
                componentSelectorTableViewHeaderButtonTouched = nil
            }
            return false
        }
        return false
    }
    
    private func cellWithPoint(point: CGPoint) -> ComponentSelectorTableViewCell? {
        if let indexPath = componentSelectorTableView.indexPathForRowAtPoint(point) {
            if let cell = componentSelectorTableView.cellForRowAtIndexPath(indexPath)
                as? ComponentSelectorTableViewCell
            {
                return cell
            }
            return nil
        }
        return nil
    }
    
    private func hitCellWithPoint(point: CGPoint) -> Bool {
        if let cell = cellWithPoint(point) {
            cell.goToNextState()
            return true
        }
        return false
    }
    
    private func dragHeaderViewButtonWithPoint(point: CGPoint) -> Bool {
        if let headerView = headerViewWithPoint(point) {
            if headerView.frame.contains(point) {
                if let headerButton = headerButtonForHeaderView(headerView) {
                    if headerButton !== componentSelectorTableViewHeaderButtonTouched {
                        headerButton.pressed()
                        componentSelectorTableViewHeaderButtonTouched = headerButton
                        return true
                    }
                    return false
                }
                return false
            }
            return false
        }
        return false
    }
    
    private func hitHeaderViewButtonWithPoint(point: CGPoint) -> Bool {
        if let headerView = headerViewWithPoint(point) {
            if headerView.frame.contains(point) {
                if let headerButton = headerButtonForHeaderView(headerView) {
                    headerButton.pressed()
                    return true
                }
                return false
            }
            return false
        }
        return false
    }
    
    private func headerButtonForHeaderView(headerView: UITableViewHeaderFooterView)
        -> ComponentSelectorTableViewHeaderButton?
    {
        for subview in headerView.subviews {
            if let button = subview as? ComponentSelectorTableViewHeaderButton {
                return button
            }
        }
        return nil
    }
    
    private func headerViewWithPoint(point: CGPoint) -> UITableViewHeaderFooterView? {
        if let indexPath = componentSelectorTableView.indexPathForRowAtPoint(point) {
            return componentSelectorTableView.headerViewForSection(indexPath.section)
        }
        return nil
    }

    private func positionSystemUIViews() {
        pageViews.forEach { $0.positionSystemViews() }
    }
    
    private func createSystemUIViewsForSystemLayers(systemLayers: [SystemLayer]) {
        systemViews = []
        for systemLayer in systemLayers {
            let systemView = SystemView(system: systemLayer)
            systemViews.append(systemView)
        }
    }
    
    // TODO: CLEAN UP
    // can this be encapsulated in a class (or even a class func)
    private func makePageViewsWithSystemLayers(systemLayers: [SystemLayer]) -> [PageView] {

        var pageViews: [PageView] = []
        
        let margin: CGFloat = 25
        let maximumHeight = UIScreen.mainScreen().bounds.height - 2 * margin
        var systemIndex: Int = 0
        while systemIndex < systemLayers.count {
            
            do {
                // get `Systems` that fit vertically in the allowable space
                let systemLayerRange = try SystemLayer.rangeFromSystemLayers(systemLayers,
                    startingAtIndex: systemIndex,
                    constrainedByMaximumTotalHeight: maximumHeight
                )
                
                // create corresponding `SystemViews` for `Systems`
                let systemViewRange = systemViewsFrom(systemIndex, to: systemLayerRange.count)
                
                // create `PageLayer` containing the `SystemLayer` range
                let pageLayer = PageLayer(systemLayers: systemLayerRange)
                
                // create corresponding `PageView` containing the `SystemView` range
                let pageView = PageView(
                    pageLayer: pageLayer, systemViews: systemViewRange, scoreView: self
                )
                // add and go on
                pageViews.append(pageView)
                systemIndex += systemLayerRange.count
            }
            catch {
                print("could not create systemRange: \(error)")
            }
        }
        return pageViews
    }
    
    private func systemViewsFrom(start: Int, to amount: Int) -> [SystemView] {
        return Array(systemViews[start..<start + amount])
    }
    
    private func makeSystemLayersWithSystems(systemModels: [SystemModel]) -> [SystemLayer] {
        return SystemLayerFactory(
            systemModels: systemModels,
            viewerProfile: viewModel.viewerProfile,
            componentFilters: viewModel.componentFilters,
            graphicalAttributeSpecifier: SystemGraphicalAttributeSpecifier(
                beatWidth: defaultBeatWidth,
                sizeSpecifier: StaffTypeSizeSpecifier(staffSpaceHeight: defaultStaffHeight)
            )
        ).makeSystemLayers()
    }
    
    private func buildSystemLayers(systemLayers: [SystemLayer]) {
        systemLayers.forEach { $0.build() }
    }
    
    private func makeSystems() -> [SystemModel] {
        let margin: CGFloat = 25
        let maximumWidth = frame.width - 2 * margin
        let beatWidth: CGFloat = 110 // hack, make not static
        let systems = SystemModel.rangeWithScoreModel(viewModel.scoreModel,
            beatWidth: beatWidth,
            maximumWidth: maximumWidth
        )
        return systems
    }
    
    private func removeCurrentPageView() {
        if let currentPageView = currentPageView { currentPageView.removeFromSuperview() }
    }
    
    private func getCurrentPageIndex() -> Int? {
        if let currentPageView = currentPageView { return pageViews.indexOf(currentPageView) }
        return nil
    }
    
    private func setFrame() {
        let marginTop: CGFloat = 25
        let marginLeft: CGFloat = 50
        let width = UIScreen.mainScreen().bounds.width - marginLeft
        let height = UIScreen.mainScreen().bounds.height - marginTop
        frame = CGRect(origin:
            CGPoint(x: marginLeft, y: marginTop), size: CGSize(width: width, height: height)
        )
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        componentSelectorTableViewCellTouched = nil
    }
}

// refactor out of here
extension ScoreView: UITableViewDelegate {
    
    public func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath
    )
    {
        updateCellInTableView(tableView, atIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView,
        didDeselectRowAtIndexPath indexPath: NSIndexPath
    )
    {
        updateCellInTableView(tableView, atIndexPath: indexPath)
    }
    
    private func updateCellInTableView(tableView: UITableView,
        atIndexPath indexPath: NSIndexPath
        )
    {
        if let cell = tableView.cellForRowAtIndexPath(indexPath)
            as? ComponentSelectorTableViewCell
        {
            updateCell(cell)
        }
    }
    
    public func muteCellsInSection(section: Int) {
        cellsInSection(section).forEach { $0.mute() }
    }
    
    public func unmuteCellsInSection(section: Int) {
        cellsInSection(section).forEach { $0.unmute() }
    }
    
    private func updateCell(cell: ComponentSelectorTableViewCell) {
        cell.goToNextState()
    }
    
    private func cellsInSection(section: Int) -> [ComponentSelectorTableViewCell] {
        var cells: [ComponentSelectorTableViewCell] = []
        for row in 0..<componentSelectorTableViewModels[section].1.count {
            let indexPath = NSIndexPath(forRow: row, inSection: section)
            if let cell = componentSelectorTableView.cellForRowAtIndexPath(indexPath)
                as? ComponentSelectorTableViewCell
            {
                cells.append(cell)
            }
        }
        return cells
    }
}

// MARK: - UITableViewDataSource
extension ScoreView: UITableViewDataSource {
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let cellModel = componentSelectorTableViewModels[indexPath.section].1[indexPath.row]
        let cell = ComponentSelectorTableViewCell(model: cellModel)
        cell.updateView()
        return cell
    }

    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int)
        -> UIView?
    {
        let headerModel = componentSelectorTableViewModels[section].0
        
        // create view with a button on it
        let headerView = UITableViewHeaderFooterView()
        let frame = CGRect(x: 5, y: 5, width: tableView.frame.width - 10, height: 20)
        let button = ComponentSelectorTableViewHeaderButton(model: headerModel, frame: frame)
        button.delegate = self
        headerView.addSubview(button)
        headerView.tag = section
        return headerView
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return componentSelectorTableViewModels[section].1.count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return componentSelectorTableViewModels.count
    }
    
    // deprecate -- implement tablve view view for header in section
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int)
        -> String?
    {
        return componentSelectorTableViewModels[section].0.text
    }
}

public protocol ComponentSelectorTableViewHeaderButtonDelegate {
    func didPressHeaderButton(button: ComponentSelectorTableViewHeaderButton)
}
