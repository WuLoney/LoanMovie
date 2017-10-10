//
//  MBSmallView.swift
//  LoanMovie
//
//  Created by maiGit on 2017/9/30.
//  Copyright © 2017年 maiGit. All rights reserved.
//

import UIKit

class MBSmallView: UIView {
    
    private var smalDelegate: MBProtocolDelegate?
    private var scaleNumber: Int = 0
    
    private lazy var contentLabel: UILabel = {
       let label = UILabel.init(frame: .zero)
        label.clipsToBounds = true
        label.textColor = UIColor.red
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 160)
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLabel.frame = self.frame
    }
    
    /// 开始倒计时方法
    ///
    /// - Parameters:
    ///   - startNumber: 倒计时时间
    ///   - delegate: self
    func playWithNumber(startNumber: Int, delegate: MBProtocolDelegate) {
        scaleNumber  = startNumber
        smalDelegate = delegate
        smalDelegate?.countdownBegin()
        startAnimator()
    }
    
    func startAnimator() {
        UIView.animate(withDuration: 1, animations: {
            self.contentLabel.transform = CGAffineTransform.identity
            self.contentLabel.alpha = 0.5
        }) { (finshed) in
            if finshed {
                self.contentLabel.text = "\(self.scaleNumber)"
                if self.scaleNumber < 1 {
                    self.smalDelegate?.countdownSuccess()
                } else {
                    self.scaleNumber -= 1
                    self.contentLabel.alpha = 0.0
                    self.contentLabel.transform = CGAffineTransform(scaleX: 4, y: 4)
                    self.startAnimator()
                }
            }
        }
    }
}
