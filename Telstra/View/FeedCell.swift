//
//  FeedCell.swift
//  Telstra
//
//  Created by suitecontrol on 6/4/20.
//  Copyright © 2020 suitecontrol. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    /**
     *  The feed's thumbnail picture
     */
    let thumbnailImage: UIImageView = {
       let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 50, height: 50))
        imageView.backgroundColor = UIColor.lightGray
        return imageView
    }()
    
    /**
     * The feed's title
     */
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.darkText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    /**
     * The feed's description
     */
    let descLabel: UILabel = {
       let label = UILabel()
       label.font = UIFont.systemFont(ofSize: 15)
       label.textColor = UIColor.darkText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(thumbnailImage)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descLabel)
        
        configureThumbnailImageConstraints()
        configureTitleLabelConstraints()
        configureDescLabelConstraints()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
        
    private func configureThumbnailImageConstraints() {
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImage.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant: 5).isActive = true
        thumbnailImage.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        thumbnailImage.widthAnchor.constraint(equalToConstant:50).isActive = true
        thumbnailImage.heightAnchor.constraint(equalToConstant:50).isActive = true
    }
    
    private func configureTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo:thumbnailImage.trailingAnchor, constant:8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant:21).isActive = true
    }
    
    private func configureDescLabelConstraints() {
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.topAnchor.constraint(equalTo:titleLabel.bottomAnchor, constant: 5).isActive = true
        descLabel.leadingAnchor.constraint(equalTo:thumbnailImage.trailingAnchor, constant:8).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 8).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true

    }
}
