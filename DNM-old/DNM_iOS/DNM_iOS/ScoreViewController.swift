//
//  ScoreViewController.swift
//  DNM_iOS
//
//  Created by James Bean on 11/26/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel

public class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI
    
    @IBOutlet weak var previousPageButton: UIButton!
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    /// TableView that shows Views to select (one for each performer, and "omni": full score)
    public var viewSelectorTableView: UITableView!
    
    private var viewSelectorTableViewCenterX: CGFloat = 0
    
    // MARK: - Score Views
    
    /// All ScoreViews organized by ID
    private var scoreViewByID = OrderedDictionary<PerformerID, ScoreView>()

    /// All Viewers of this Score, which are each given their own ScoreView
    private var viewers: [Viewer] = []
    
    // Identifiers for each PerformerStratum in the ensemble
    private var performerIDs: [PerformerID] = []
    
    /// ScoreView currently displayed
    private var currentScoreView: ScoreView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupScoreViewTableView()
    }
    
    /**
    Show a score with a given ScoreModel

    - parameter scoreModel: ScoreModel
    */
    public func showScoreWithScoreModel(scoreModel: ScoreModel) {
        let scoreViews = makeScoreViewsWithScoreModel(scoreModel)
        setScoreViewByIDWithScoreViews(scoreViews)
        manageColorMode()
        build()
    }

    private func build() {
        viewSelectorTableView.reloadData()
        manageEdgePanGestureRecognizers()
        selectOmniViewAsDefault()
        goToFirstPage()
    }
    
    private func makeScoreViewsWithScoreModel(scoreModel: ScoreModel) -> [ScoreView] {
        let viewers = makeViewersWithScoreModel(scoreModel)
        let scoreViews = makeScoreViewsWithViewers(viewers, andScoreModel: scoreModel)
        return scoreViews
    }

    // MARK: ScoreView Management
    
    private func setScoreViewByIDWithScoreViews(scoreViews: [ScoreView]) {
        scoreViewByID = scoreViews.reduce(OrderedDictionary<String, ScoreView>()) {
            aggregate, element in
            var newDict = OrderedDictionary<String, ScoreView>()
            newDict[element.viewModel.viewerProfile.viewer.identifier] = element
            return aggregate + newDict
        }
    }
    
    private func selectOmniViewAsDefault() {
        if let row = rowForOmniCell() {
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            viewSelectorTableView.selectRowAtIndexPath(indexPath,
                animated: false,
                scrollPosition: UITableViewScrollPosition.None
            )
            showScoreViewWithID("omni")
        }
    }
    
    private func rowForOmniCell() -> Int? {
        for (r, (id, _)) in scoreViewByID.enumerate() { if id == "omni" { return r } }
        return nil
    }

    /**
    Show the ScoreView with a PerformerID
    
    - parameter id: PerformerID
    */
    public func showScoreViewWithID(id: PerformerID) {
        if let scoreView = scoreViewByID[id] {
            removeCurrentScoreView()
            showScoreView(scoreView)
        }
    }
    
    private func makeViewersWithScoreModel(scoreModel: ScoreModel) -> [Viewer] {
        return scoreModel.instrumentTypeModel.keys.map {
            Viewer(identifier: $0, type: .Performer)
        } + [ViewerOmni]
    }
    
    private func makeScoreViewsWithViewers(viewers: [Viewer],
        andScoreModel scoreModel: ScoreModel
    ) -> [ScoreView]
    {
        return viewers.map {
            let profile = ViewerProfile(allViewers: viewers, currentViewer: $0)
            let viewModel = ScoreViewModel(scoreModel: scoreModel, viewerProfile: profile)
            return ScoreView(viewModel: viewModel)
        }
    }

    private func showScoreView(scoreView: ScoreView) {
        view.insertSubview(scoreView, atIndex: 0)
        currentScoreView = scoreView
    }
    
    private func removeCurrentScoreView() {
        if let currentScoreView = currentScoreView { currentScoreView.removeFromSuperview() }
    }

    // MARK: - UI Setup
    
    private func setupScoreViewTableView() {
        viewSelectorTableView = UITableView(
            frame: CGRect(x: 0, y: 20, width: 100, height: 400)
        )
        viewSelectorTableView.delegate = self
        viewSelectorTableView.dataSource = self
        viewSelectorTableView.scrollEnabled = false
        view.addSubview(viewSelectorTableView)
        addSwipeGestureToViewSelectorTableView()
        positionViewSelectorTableViewOffscreen()
    }
    
    private func addSwipeGestureToViewSelectorTableView() {
        let gestureRecognizer = UISwipeGestureRecognizer(
            target: self, action: "hideViewSelectorTableView"
        )
        gestureRecognizer.direction = .Left
        viewSelectorTableView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func manageEdgePanGestureRecognizers() {
        let leftEdgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(
            target: self, action: "showViewSelectorTableView"
        )
        leftEdgeGestureRecognizer.edges = UIRectEdge.Left
        view.addGestureRecognizer(leftEdgeGestureRecognizer)
    }
    
    public func showViewSelectorTableView() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.1)
        var newFrame = viewSelectorTableView.frame
        newFrame.origin.x = 20
        viewSelectorTableView.frame = newFrame
        UIView.commitAnimations()
    }
    
    public func hideViewSelectorTableView() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.15)
        var newFrame = viewSelectorTableView.frame
        newFrame.origin.x = -newFrame.width
        viewSelectorTableView.frame = newFrame
        UIView.commitAnimations()
    }
    
    private func manageColorMode() {
        view.backgroundColor = DNMColorManager.backgroundColor
        setViewSelectorTableViewBackground()
    }
    
    private func setViewSelectorTableViewBackground() {
        let bgView = UIView()
        bgView.backgroundColor = DNMColorManager.backgroundColor
        viewSelectorTableView.backgroundView = bgView
    }
    
    // MARK: - PageLayer Navigation
    
    /**
    Go to the first page of the currently displayed ScoreView
    */
    public func goToFirstPage() {
        currentScoreView?.goToFirstPage()
    }

    /**
    Go to the last page of the currently displayed ScoreView
    */
    public func goToLastPage() {
        currentScoreView?.goToLastPage()
    }
    
    /**
    Go to the next page of the currently displayed ScoreView
    */
    public func goToNextPage() {
        currentScoreView?.goToNextPage()
    }
    
    /**
    Go to the previous page of the currently displayed ScoreView
    */
    public func goToPreviousPage() {
        currentScoreView?.goToPreviousPage()
    }
    
    @IBAction func didPressPreviousButton(sender: UIButton) {
        goToPreviousPage()
    }
    
    @IBAction func didPressNextButton(sender: UIButton) {
        goToNextPage()
    }
    
    private func resizeViewSelectorTableView() {
        viewSelectorTableView.resizeToFitContents()
    }
    
    private func positionViewSelectorTableViewOffscreen() {
        viewSelectorTableView.layer.position.x = -0.5 * viewSelectorTableView.frame.width
    }
    
    private func positionViewSelectorTableView() {
        let pad: CGFloat = 20
        let right = view.bounds.width
        let centerX = right - 0.5 * viewSelectorTableView.frame.width - pad
        viewSelectorTableView.layer.position.x = centerX
        viewSelectorTableViewCenterX = centerX
    }
    
    // MARK: - View Selector UITableViewDelegate

    public func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath
    )
    {
        if let identifier = (tableView.cellForRowAtIndexPath(indexPath)
            as? ScoreSelectorTableViewCell)?.identifier
        {
            showScoreViewWithID(identifier)
        }
        hideViewSelectorTableView()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreViewByID.count
    }
    
    // extend beyond title
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let cell = ScoreSelectorTableViewCell()
        let viewerID = scoreViewByID.keys[indexPath.row]
        
        // do all this in ScoreSelectorTableViewCell implementation
        cell.identifier = viewerID
        cell.textLabel?.text = viewerID
        setVisualAttributesOfTableViewCell(cell)
        resizeViewSelectorTableView()
        return cell
    }

    // do this in ScoreSelectorTableViewCell
    private func setVisualAttributesOfTableViewCell(cell: UITableViewCell) {
        cell.textLabel?.textColor = DNMColor.grayscaleColorWithDepthOfField(.Foreground)
        cell.backgroundColor = DNMColor.grayscaleColorWithDepthOfField(.Background)

        let selBGView = UIView()
        selBGView.backgroundColor = DNMColor.grayscaleColorWithDepthOfField(.Middleground)
        cell.selectedBackgroundView = selBGView
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
