//
//  VideoHeaderView.swift
//  LoanMovie
//
//  Created by maiGit on 2017/9/14.
//  Copyright © 2017年 maiGit. All rights reserved.
//

import UIKit
import CoreText
import CoreFoundation

typealias StartRecordingPass = ()->Void

class VideoHeaderView: UIView {
    
    @IBOutlet weak var textCollectionView: UICollectionView!
    private lazy var collectionViewCells = [CoustomCollectionCell]()
    
    private var textArray = ["不", "是", "看", "到", "希",
                             "望", "才", "坚", "持", ",", "而",
                             "是", "坚", "持", "才", "会",
                             "看", "到", "希", "望"]
    
    // 下标索引
    private var indexNum: Int = 0
    var startAction: StartRecordingPass?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var successBtn: JButton!
    /// MARK 开始朗读
    @IBAction func startRecordingVideoEvent(_ sender: UIButton) {
        if startAction != nil {
            startAction?()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textCollectionView.delegate = self
        textCollectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        flowLayout.itemSize = CGSize(width:(textCollectionView.bounds.width - 13)/12,
                                     height:(textCollectionView.bounds.width - 13)/12 + 16)
        
        textCollectionView.collectionViewLayout = flowLayout
        textCollectionView.register(UINib(nibName: "CoustomCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TextIdentifier")
    }
    
    /** 开始动画 */
    func startShimmer(_ maskLabel: UILabel) {
        if indexNum <= collectionViewCells.count {
            var start3D = CATransform3DIdentity
            var end3D   = CATransform3DIdentity
            let translate = CABasicAnimation(keyPath: "transform")
            translate.duration = 0.3
            translate.repeatCount = 0
            translate.isRemovedOnCompletion = false
            translate.fillMode = kCAFillModeForwards
            translate.delegate = self
            let maskLayer = CALayer()
            maskLayer.removeFromSuperlayer()
            maskLayer.frame = CGRect(x:0,y:0, width:maskLabel.frame.width, height:maskLabel.frame.height)
            maskLayer.backgroundColor = UIColor.white.cgColor
            start3D = CATransform3DMakeTranslation(-1, 0, 1)
            end3D   = CATransform3DMakeTranslation(maskLabel.frame.width, 0, 1)
            maskLabel.layer.addSublayer(maskLayer)
            // mask 一个可选的层，其alpha通道用于屏蔽图层的内容。
            maskLabel.layer.mask = maskLayer
            maskLayer.transform = start3D
            translate.fromValue = NSValue(caTransform3D: start3D)
            translate.toValue   = NSValue(caTransform3D: end3D)
            maskLayer.removeAllAnimations()
            maskLayer.add(translate, forKey: "start")
        }
    }
    
    public func startCellTextAnimations() {
       startShimmer(collectionViewCells[indexNum].maskLabel)
    }
    
    public func stopCellTextAnimations() {
        indexNum = 10000
        for (_, cell) in collectionViewCells.enumerated() {
            cell.maskLabel.layer.removeAllAnimations()
            cell.maskLabel.layer.mask = nil
        }
    }
    
    /// 完成朗读
    public func successReadBtnAction() {
        indexNum = 0
        startCellTextAnimations()
        successBtn.isDownTimer = true
    }
    
    /// 播放写入的视频数据
    public func playWriteVideoData(_ isShow: Bool) {
        if isShow {
            titleLabel.text = "请大声朗读以下文字"
            successBtn.isHidden = false
            successBtn.setTitle("开始朗读", for: UIControlState.normal)
        } else {
            titleLabel.text = "正在回放朗读内容，请检查确认..."
            successBtn.isHidden = true
        }
    }
}

extension VideoHeaderView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        indexNum += 1
        if indexNum < collectionViewCells.count {
            startCellTextAnimations()
        }
    }
}

extension VideoHeaderView : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextIdentifier", for: indexPath) as! CoustomCollectionCell
        cell.drawChines(textArray[indexPath.row])
        collectionViewCells.append(cell)
        switch indexPath.row {
        case 6:
            cell.toneLabel.text = "cai"
        case 13:
            cell.toneLabel.text = "chi"
        default:
            cell.toneLabel.text = ""
        }
        return cell
    }
}

class CoustomCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var toneLabel: UILabel!
    /// 默认显示 Label
    @IBOutlet weak var contentLabel: UILabel!
    /// 蒙版显示 Label
    @IBOutlet weak var maskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func drawChines(_ value: String) {
        contentLabel.text = value
        maskLabel.text = value
    }
}
