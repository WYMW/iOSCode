//
//  DownloadCell.swift
//  NSOperationDemo
//
//  Created by WangWei on 12/1/17.
//  Copyright © 2017年 WangWei. All rights reserved.
//

import UIKit

class DownloadCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var bytesWritten: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
