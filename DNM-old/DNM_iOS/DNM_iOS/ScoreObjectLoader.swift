//
//  ScoreObjectLoader.swift
//  DNM
//
//  Created by James Bean on 1/10/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Foundation
import Bolts
import Parse


// TODO: Implement, but need to figure out concurrency issue with Parse background block

/*
/// Loads ScoreObjects from Parse
public class ScoreObjectLoader {
    
    private var allScoreObjects: [PFObject] = []
    
    public func scoreObjecsForUsername(username: String) -> [PFObject] {

        //var scoreObjects: [PFObject] = []
        fetchScoreObjectsFromLocalDatastoreForUsername(username)
        fetchScoreObjectsForUsername(username)
        print("all score objects: \(allScoreObjects)")
        
        /*
        let query = PFQuery(className: "Score")
        query.fromLocalDatastore()
        query.whereKey("username", equalTo: username)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> () in
            if let error = error { print(error) }
            else if let objects = objects { scoreObjects = objects }
        }
        print("scoreObjects: \(scoreObjects)")
        */
        
        return mostRecentVersionsOfScoreObjects(allScoreObjects)
    }
    
    private func fetchScoreObjectsFromLocalDatastoreForUsername(username: String) {
        let query = PFQuery(className: "Score")
        query.fromLocalDatastore()
        query.whereKey("username", equalTo: username)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> () in
            if let error = error { print(error) }
            else if let objects = objects {
                self.allScoreObjects = objects
            }
        }
    }
    
    private func fetchScoreObjectsForUsername(username: String) {
        PFObject.unpinAllObjectsInBackground()
        let query = PFQuery(className: "Score")
        query.whereKey("username", equalTo: username)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> () in
            if let objects = objects where error == nil {
                self.allScoreObjects = objects
                do {
                    try PFObject.pinAll(objects)
                } catch {
                    print("couldnt pin")
                }
                self.fetchScoreObjectsFromLocalDatastoreForUsername(username)
            }
        }
    }
    
    private func mostRecentVersionsOfScoreObjects(scoreObjects: [PFObject]) -> [PFObject] {
        let scoreObjectsByTitle = organizeScoreObjectsByTitle(scoreObjects)
        let newestScores = newestScoreObjectByTitleForScoreObjectsByTitle(scoreObjectsByTitle)
        return newestScores.map { $0.1 }
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
    
    private func organizeScoreObjectsByTitle(scoreObjects: [PFObject]) -> [String: [PFObject]]
    {
        var scoreObjectsByTitle: [String: [PFObject]] = [:]
        for scoreObject in scoreObjects {
            if let title = scoreObject["title"] as? String {
                if scoreObjectsByTitle[title] == nil { scoreObjectsByTitle[title] = [] }
                scoreObjectsByTitle[title]!.append(scoreObject)
            }
        }
        return scoreObjectsByTitle
    }
}
*/