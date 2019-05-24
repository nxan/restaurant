//
//  DeskCell.swift
//  Restaurant
//
//  Created by NXA on 5/2/19.
//  Copyright © 2019 NXA. All rights reserved.
//

import UIKit

class DeskCell: UICollectionViewCell {
    
    @IBOutlet private weak var labelDeskId: UILabel!
    @IBOutlet private weak var labelTime: UILabel!
    @IBOutlet private weak var labelCountOrder: UILabel!
    @IBOutlet private weak var labelStatus: UILabel!
    
    var time = Date()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelDeskId.textColor = UIColor.black
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.masksToBounds = false
    }
    
    func configureWith(_ desk: Desk) {
        labelDeskId.text = "Số bàn: \(desk.deskName)"
        labelCountOrder.text = "Số món gọi: \(desk.count)"
        if(desk.enable) {
            labelStatus.text = "Trạng thái: Đã có người"
            let minute = (time.minute < 10) ? "0\(time.minute)" : "\(time.minute)"
            labelTime.text = "Thời gian vào: \(time.hour):\(minute)"
            labelStatus.textColor = UIColor.vegaGreen
        } else {
            labelStatus.text = "Trạng thái: Trống"
            labelTime.text = "Thời gian vào: Trống"
            labelStatus.textColor = UIColor(rgb: 0xF93C64)
        }
    }
    
    
    
    private func twoDigitsFormatted(_ val: Double) -> String {
        return String(format: "%.0.2f", val)
    }
    
    
}
