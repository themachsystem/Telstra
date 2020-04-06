//
//  AppManager.swift
//  Telstra
//
//  Created by suitecontrol on 30/3/20.
//  Copyright © 2020 suitecontrol. All rights reserved.
//

import UIKit

class AppManager: NSObject {
    // MARK: - Properties
    // MARK: Public
    static let shared = AppManager()
    
    /**
     * Contains all the feed
     */
    var info: Info?
    
    override init() {
        super.init()
    }

    
    // MARK: - Public methods
    /**
     * Downloads and parses JSON feed and calls a handler upon completion.
     */
    func downloadFeed(completionHandler: @escaping (_ success: Bool) -> Void) {
        weak var weakSelf = self
        NetworkManager.shared.runDataTask(url: feedUrl) { response,error  in
            if let responseObject = response {
                weakSelf!.info = weakSelf!.infoFromServerResponse(responseObject)
            }
            completionHandler(weakSelf!.info != nil)
        }
    }
    
    // MARK: - Private methods
    
    /**
     * Reads server response and constructs into an Info object.
     */
    private func infoFromServerResponse(_ serverResponse: Dictionary<String,Any>) -> Info? {
        guard let feedRows = serverResponse["rows"] as? [[String:Any]] else {
            return nil
        }
        var feedList = [Feed]()
        for row in feedRows {
            let title = row["title"] as? String
            let desc = row["description"] as? String
            let imageUrl = row["imageHref"] as? String
            if title == nil && desc == nil && imageUrl == nil {
                continue
            }
            print(desc)
            let feed = Feed()
            feed.title = title
            feed.desc = desc
            feed.imageUrl = imageUrl
            
            feedList.append(feed)
        }
        let info = Info()
        if let infoTitle = serverResponse["title"] as? String {
            info.title = infoTitle
        }
        info.feedList = feedList
        return info
    }
}
