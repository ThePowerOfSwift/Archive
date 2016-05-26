//
//  MasterViewController.swift
//  DNM_iOS
//
//  Created by James Bean on 11/26/15.
//  Copyright © 2015 James Bean. All rights reserved.
//

import UIKit
import DNMModel
import Parse
import Bolts

// TODO: manage signed in / signed out: tableview.reloadData
// TODO: refactor username / password management to another class
public class MasterViewController: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate
{
    // MARK: - UI
    
    @IBOutlet weak var scoreSelectorTableView: UITableView!
    @IBOutlet weak var colorModeLabel: UILabel!
    @IBOutlet weak var colorModeLightLabel: UILabel!
    @IBOutlet weak var colorModeDarkLabel: UILabel!
    @IBOutlet weak var loginStatusLabel: UILabel!
    @IBOutlet weak var signInOrOutOrUpButton: UIButton!
    @IBOutlet weak var signInOrUpButton: UIButton!
    @IBOutlet weak var dnmLogoLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: - Model
    
    private var scoreModelSelected: ScoreModel?
    
    // MARK: - Views
    
    // change to PerformerInterfaceView
    private var viewByID: [String: ScoreView] = [:]
    private var currentView: ScoreView?
    
    // MARK: - Score Object Management
    
    private var allScoreObjects: [PFObject] = []
    
    private var scoreObjects: [PFObject] = []
    private var loginState: LoginState = .SignIn
    
    // MARK: - Startup
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScoreSelectorTableView()
        setupTextFields()
    }
    
    public override func viewDidAppear(animated: Bool) {
        manageLoginStatus()
        manageScoreObjects()
    }
    
    private func setupView() {
        updateUIForColorMode()
    }
    
    private func setupScoreSelectorTableView() {
        scoreSelectorTableView.delegate = self
        scoreSelectorTableView.dataSource = self
    }
    
    private func setupTextFields() {
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    // MARK: - UI
    
    @IBAction func didEnterUsername(sender: AnyObject) {
        
        // move on to password field
        passwordField.becomeFirstResponder()
    }
    
    
    @IBAction func didEnterPassword(sender: AnyObject) {
        
        if let username = usernameField.text, password = passwordField.text {
            
            // make sure the username and password is legit legit
            if username.characters.count > 0 && password.characters.count >= 8 {
                
                // disable keyboard
                passwordField.resignFirstResponder()
                
                // don't do this by the text of the button: enum LoginState { }
                switch signInOrOutOrUpButton.currentTitle! {
                case "SIGN UP":
                    let user = PFUser()
                    user.username = username
                    user.password = password
                    do {
                        try user.signUp()
                        enterSignedInMode()
                    }
                    catch {
                        print("could not sign up user")
                        // manage this in the UI
                    }
                    
                case "SIGN IN":
                    do {
                        try PFUser.logInWithUsername(username, password: password)
                        enterSignedInMode()
                    }
                    catch {
                        print(error)
                    }
                default: break
                }
            }
        }
    }
    
    @IBAction func didPressSignInOrOutOrUpButton(sender: AnyObject) {
        // don't do this with the text
        if let title = signInOrOutOrUpButton.currentTitle {
            if title == "SIGN OUT?" {
                if PFUser.currentUser() != nil {
                    PFUser.logOutInBackground()
                    scoreObjects = []
                    scoreSelectorTableView.reloadData()
                    enterSignInMode()
                }
            }
        }
    }
    
    @IBAction func didPressSignInOrUpButton(sender: AnyObject) {
        // don't do this with text!
        if let title = signInOrUpButton.currentTitle {
            if title == "SIGN UP?" {
                enterSignUpMode()
            } else if title == "SIGN IN?" {
                enterSignInMode()
            }
        }
    }
    
    @IBAction func didChangeValueOfSwitch(sender: UISwitch) {
        
        // state on = dark, off = light
        switch sender.on {
        case true: DNMColorManager.colorMode = ColorMode.Dark
        case false: DNMColorManager.colorMode = ColorMode.Light
        }
        updateUIForColorMode()
    }
    
    private func updateUIForColorMode() {
        scoreSelectorTableView.reloadData()
        setBackgroundColor()
        setScoreSelectorTableViewBackgroundColor()
        setLoginStatusLabelTextColor()
        setColorModeLabelTextColors()
        setUsernameAndPasswordTextFieldColors()
        setDNMLogoLabelTextColor()
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = DNMColorManager.backgroundColor
    }
    
    private func setDNMLogoLabelTextColor() {
        dnmLogoLabel.textColor = DNMColor.grayscaleColorWithDepthOfField(.Foreground)
    }
    
    private func setUsernameAndPasswordTextFieldColors() {
        usernameField.backgroundColor = DNMColor.grayscaleColorWithDepthOfField(.Background)
        usernameField.textColor = DNMColor.grayscaleColorWithDepthOfField(.Foreground)
        passwordField.backgroundColor = DNMColor.grayscaleColorWithDepthOfField(.Background)
        passwordField.textColor = DNMColor.grayscaleColorWithDepthOfField(.Foreground)
    }
    
    private func setColorModeLabelTextColors() {
        colorModeLabel.textColor = DNMColor.grayscaleColorWithDepthOfField(.Foreground)
        colorModeLightLabel.textColor = DNMColor.grayscaleColorWithDepthOfField(.Foreground)
        colorModeDarkLabel.textColor = DNMColor.grayscaleColorWithDepthOfField(.Foreground)
    }
    
    private func setScoreSelectorTableViewBackgroundColor() {
        let bgView = UIView()
        bgView.backgroundColor = DNMColorManager.backgroundColor
        scoreSelectorTableView.backgroundView = bgView
    }
    
    private func setLoginStatusLabelTextColor() {
        loginStatusLabel.textColor = DNMColor.grayscaleColorWithDepthOfField(.MiddleForeground)
    }
    
    
    func updateLoginStatusLabel() {
        if let username = PFUser.currentUser()?.username {
            loginStatusLabel.hidden = false
            loginStatusLabel.text = "logged in as \(username)"
        } else {
            loginStatusLabel.hidden = true
        }
    }
    
    private func showScoreSelectorTableView() {
        scoreSelectorTableView.hidden = false
    }
    
    private func hideScoreSelectorTableView() {
        scoreSelectorTableView.hidden = true
    }
    
    // MARK: - Parse Management
    
    func manageLoginStatus() {
        PFUser.currentUser() == nil ? enterSignInMode() : enterSignedInMode()
    }
    
    func enterSignInMode() {
        
        // hide score selector table view -- later: animate offscreen left
        hideScoreSelectorTableView()
        
        signInOrOutOrUpButton.hidden = false
        signInOrOutOrUpButton.setTitle("SIGN IN", forState: .Normal)
        
        signInOrUpButton.hidden = false
        signInOrUpButton.setTitle("SIGN UP?", forState: .Normal)
        
        loginStatusLabel.hidden = true
        
        usernameField.hidden = false
        passwordField.hidden = false
    }
    
    // signed in
    func enterSignedInMode() {
        manageScoreObjects()
        showScoreSelectorTableView()
        updateLoginStatusLabel()
        
        // hide username field, clear contents
        usernameField.hidden = true
        usernameField.text = nil
        
        // hide password field, clear contents
        passwordField.hidden = true
        passwordField.text = nil
        
        signInOrUpButton.hidden = true
        
        signInOrOutOrUpButton.hidden = false
        signInOrOutOrUpButton.setTitle("SIGN OUT?", forState: .Normal)
    }
    
    
    
    // need to sign up
    func enterSignUpMode() {
        signInOrOutOrUpButton.setTitle("SIGN UP", forState: .Normal)
        signInOrUpButton.setTitle("SIGN IN?", forState: .Normal)
    }
    
    // MARK: - UITableViewDelegate Methods
    
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell",
            forIndexPath: indexPath
        ) as! ScoreSelectorTableViewCell
        
        // text
        cell.textLabel?.text = scoreObjects[indexPath.row]["title"] as? String
        
        // color
        cell.textLabel?.textColor = DNMColor.grayscaleColorWithDepthOfField(.Foreground)
        cell.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: 16)
        cell.backgroundColor = DNMColor.grayscaleColorWithDepthOfField(.Background)
        
        // wrap up
        let selBGView = UIView()
        selBGView.backgroundColor = DNMColor.grayscaleColorWithDepthOfField(.Middleground)
        cell.selectedBackgroundView = selBGView
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let scoreString = scoreObjects[indexPath.row]["text"] as? String {
            if let scoreModel = try? ScoreModel(string: scoreString) {
                scoreModelSelected = scoreModel
                performSegueWithIdentifier("showScore", sender: self)
            }
        }
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier where id == "showScore" {
            let scoreViewController = segue.destinationViewController as! ScoreViewController
            if let scoreModel = scoreModelSelected {
                scoreViewController.showScoreWithScoreModel(scoreModel)
            }
        }
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int)
        -> UIView?
    {
        return UIView(frame: CGRectZero)
    }
    
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreObjects.count
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Parse
    
    private func manageScoreObjects() {
        fetchAllObjectsFromLocalDatastore()
        fetchAllObjects()
    }
    
    // TODO: Refactor into own class: but need to
    
    private func fetchAllObjectsFromLocalDatastore() {
        if let username = PFUser.currentUser()?.username {
            let query = PFQuery(className: "Score")
            query.fromLocalDatastore()
            query.whereKey("username", equalTo: username)
            query.findObjectsInBackgroundWithBlock { (objects, error) -> () in
                if let error = error { print(error) }
                else if let objects = objects {
                    self.allScoreObjects = objects
                    self.filterOutDuplicateScoreObjects()
                    self.scoreSelectorTableView.reloadData()
                }
            }
        }
    }
    
    private func fetchAllObjects() {
        if let username = PFUser.currentUser()?.username {
            PFObject.unpinAllObjectsInBackground()
            let query = PFQuery(className: "Score")
            query.whereKey("username", equalTo: username)
            query.findObjectsInBackgroundWithBlock { (objects, error) -> () in
                if let objects = objects where error == nil {
                    self.allScoreObjects = objects
                    self.filterOutDuplicateScoreObjects()
                    do {
                        try PFObject.pinAll(objects)
                    } catch {
                        print("couldnt pin")
                    }
                    self.fetchAllObjectsFromLocalDatastore()
                }
            }
        }
    }

    private func filterOutDuplicateScoreObjects() {
        let scoreObjectsByTitle = organizeScoreObjectsByTitle(scoreObjects)
        let newestScores = newestScoreObjectByTitleForScoreObjectsByTitle(scoreObjectsByTitle)
        scoreObjects = newestScores.map { $0.1 }
    }
    
    private func newestScoreObjectByTitleForScoreObjectsByTitle(
        scoreObjectsByTitle: [String: [PFObject]]
        ) -> [String: PFObject]
    {
        var result: [String: PFObject] = [:]
        for (title, scoreObjects) in scoreObjectsByTitle {
            result[title] = scoreObjects
                .filter { $0.createdAt != nil }
                .sort { $0.createdAt! > $1.createdAt! }
                .first!
        }
        return result
    }
    
    private func organizeScoreObjectsByTitle(scoreObjects: [PFObject])
        -> [String: [PFObject]]
    {
        var scoreObjectsByTitle: [String: [PFObject]] = [:]
        for scoreObject in allScoreObjects {
            if let title = scoreObject["title"] as? String {
                if scoreObjectsByTitle[title] == nil { scoreObjectsByTitle[title] = [] }
                scoreObjectsByTitle[title]!.append(scoreObject)
            }
        }
        return scoreObjectsByTitle
    }
}

private enum LoginState {
    case SignedIn, SignIn, SignUp
}
