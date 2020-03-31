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
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        let rightSpacing: CGFloat = 5.0
        let leftSpacing: CGFloat = 8.0
        let imageWidth: CGFloat = 50.0
        var imageView = cell?.viewWithTag(1000) as? UIImageView
        if imageView == nil {
            imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: imageWidth, height: imageWidth))
            imageView!.tag = 1000
            imageView!.backgroundColor = UIColor.lightGray
            cell?.addSubview(imageView!)
        }
        var titleLabel = cell?.viewWithTag(1001) as? UILabel
        if titleLabel == nil {
            titleLabel = UILabel(frame: CGRect.zero)
            titleLabel!.tag = 1001
            titleLabel!.font = UIFont.systemFont(ofSize: 17)
            titleLabel!.textColor = UIColor.darkText
            cell?.addSubview(titleLabel!)
        }
        var descButton = cell?.viewWithTag(1002) as? UIButton
        if descButton == nil {
            descButton = UIButton(type: .system)
            descButton!.tintColor = UIColor.darkText
            descButton!.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            descButton!.titleLabel?.lineBreakMode = .byWordWrapping
            descButton!.contentHorizontalAlignment = .left
            descButton!.contentVerticalAlignment = .top
            descButton!.tag = 1002
            descButton!.isUserInteractionEnabled = false
            cell?.addSubview(descButton!)
        }
        
        
        let maxTextWidth: CGFloat = tableView.bounds.size.width - rightSpacing - (leftSpacing * 2) - imageWidth
        if let feed = appManager.info?.feedList?[indexPath.row] {
            if let imageUrl = feed.imageUrl {
                imageView!.sd_setImage(with: URL(string: imageUrl))
            }
            else {
                imageView!.image = nil
            }
            if let title = feed.title {
                let titleHeight = title.height(withConstrainedWidth: maxTextWidth, font: UIFont.systemFont(ofSize: 17))
                titleLabel!.frame = CGRect(x: (imageView?.frame.maxX)! + 8.0, y: 5.0, width: maxTextWidth, height: titleHeight)
                titleLabel!.text = title
            }
            else {
                titleLabel!.text = ""
            }
            if let desc = feed.desc {
                let descHeight = desc.height(withConstrainedWidth: maxTextWidth, font: UIFont.systemFont(ofSize: 17))
                descButton!.frame = CGRect(x: (titleLabel?.frame.origin.x)!, y: (titleLabel?.frame.maxY)! + 8.0,  width: maxTextWidth, height: descHeight)
                descButton!.setTitle(desc, for: .normal)
            }
            else {
                descButton!.setTitle("", for: .normal)
            }
        }
        
        return cell!
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight: CGFloat = 60.0
        let topSpacing: CGFloat = 5.0
        let spacingBetweenTexts: CGFloat = 8.0
        let bottomSpacing: CGFloat = 5.0
        var textHeight: CGFloat = topSpacing + spacingBetweenTexts + bottomSpacing
        let maxTextWidth: CGFloat = tableView.bounds.size.width * 2.0 / 3.0
        if let feed = appManager.info?.feedList?[indexPath.row] {
            if let title = feed.title  {
                let titleHeight = title.height(withConstrainedWidth: maxTextWidth, font: UIFont.systemFont(ofSize: 17))
                textHeight += titleHeight
            }
            if let desc = feed.desc  {
                let descHeight = desc.height(withConstrainedWidth: maxTextWidth, font: UIFont.systemFont(ofSize: 17))
                textHeight += descHeight
            }
        }
        return max(defaultHeight, textHeight)
    }
    
    // MARK: - Private
    func setupUI() {
        // registers table view cell class with an identifier
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // creates refresh button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(downloadFeed))
        
        // create refresh control
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(downloadFeed), for: .valueChanged)
    }
    @objc func downloadFeed() {
        SVProgressHUD.show()
        appManager.downloadFeed { success in
            if success {
                self.navigationItem.title = self.appManager.info?.title
                self.tableView.reloadData()
            }
            SVProgressHUD.dismiss()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    // Updates table view layout when device rotates
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { context in
            // This is called during the animation
        }, completion: { context in
            // This is called after the rotation is finished. Equal to deprecated `didRotate`
            self.tableView.reloadData()
        })
    }

}
