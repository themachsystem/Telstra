//
//  MainViewController.swift
//  Telstra
//
//  Created by suitecontrol on 30/3/20.
//  Copyright © 2020 suitecontrol. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class MainViewController: UITableViewController {
    let appManager = AppManager.shared
    
    private let cellIdentifier = "FeedCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        downloadFeed()
    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appManager.info?.feedList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FeedCell
        
        if let feed = appManager.info?.feedList?[indexPath.row] {
            if let imageUrl = feed.imageUrl {
                cell.thumbnailImage.sd_setImage(with: URL(string: imageUrl))
            }
            else {
                cell.thumbnailImage.image = nil
            }
            if let title = feed.title {
                cell.titleLabel.text = title
            }
            else {
                cell.titleLabel.text = ""
            }
            if let desc = feed.desc {
                cell.descLabel.text = desc
            }
            else {
                cell.descLabel.text = " "
            }
        }
        
        return cell
    }


    // MARK: - Private
    func setupUI() {
        // registers table view cell class with an identifier
        tableView.register(FeedCell.self, forCellReuseIdentifier: cellIdentifier)

        // creates refresh button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(downloadFeed))
        
        // create refresh control
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(downloadFeed), for: .valueChanged)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60

    }
    @objc func downloadFeed() {
        SVProgressHUD.show()
        
        weak var weakSelf = self
        appManager.downloadFeed { success in
            DispatchQueue.main.async {
                if success {
                    weakSelf!.navigationItem.title = weakSelf!.appManager.info?.title
                    weakSelf!.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
                else {
                    SVProgressHUD.showError(withStatus: "Unable to download feed. Please make sure you have Internet connection and try again.")
                }
                weakSelf!.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    

}
