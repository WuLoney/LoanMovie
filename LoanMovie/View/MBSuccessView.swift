//
//  MBSuccessView.swift
//  LoanMovie
//
//  Created by maiGit on 2017/10/9.
//  Copyright © 2017年 maiGit. All rights reserved.
//

import UIKit

class MBSuccessView: UIView {
    
    var delegate: MBProtocolDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func readAloudAgainEvent(_ sender: UIButton) {
        delegate?.readAloudAgain()
    }
    
    @IBAction func confirmationIsCorrectEvent(_ sender: UIButton) {
        delegate?.confirmationIsCorrect()
    }
    
    @IBAction func backBtnEvent(_ sender: UIButton) {
        delegate?.backItemSuccess()
    }
}
