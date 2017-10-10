//
//  MBFullView.swift
//  LoanMovie
//
//  Created by maiGit on 2017/9/14.
//  Copyright © 2017年 maiGit. All rights reserved.
//

import UIKit
import AVFoundation

typealias CancelBtnBlock = ()->Void

class MBFullView: UIView {
    
    private var shaperLayer: CAShapeLayer?
    private var mutablePath: CGMutablePath?
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    private var avPlay:AVPlayer?
    private var avPlayItem:AVPlayerItem?
    public var cancelBlock: CancelBtnBlock?
    private var delegate: MBProtocolDelegate?

    // =========== Stytem Method ============
    override func awakeFromNib() {
        super.awakeFromNib()
        addPlayNotification()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initShaperLayer()
    }
    
    // =========== Coustom Method ===========
    private func initShaperLayer() {
        if shaperLayer == nil {
            shaperLayer = CAShapeLayer.init()
            self.layer.addSublayer(shaperLayer!)
            shaperLayer?.fillRule = kCAFillRuleEvenOdd
            shaperLayer?.fillColor = UIColor.black.cgColor
            shaperLayer?.opacity = 0.8
            if mutablePath == nil {
                mutablePath = CGMutablePath()// 创建可变路径
                // 绘制椭圆
                mutablePath?.addEllipse(in: CGRect(x:40,
                                                  y:headerView.frame.maxY,
                                                  width:self.bounds.width - 80,
                                                  height:footerView.frame.minY - headerView.frame.maxY))
                mutablePath?.addRect(CGRect(x:0,
                                            y:headerView.frame.maxY,
                                            width:self.bounds.width,
                                            height:footerView.frame.minY - headerView.frame.maxY))
                shaperLayer?.path = mutablePath!
            }
        }
    }
    
    /// 创建播放层
    public func getRecordingCompleteVideo(_ urlFile:URL, _ dele: MBProtocolDelegate){
        delegate = dele
        let moveAsset = AVURLAsset(url:urlFile, options: nil)
        let playerItem = AVPlayerItem(asset: moveAsset)
        let play1 = AVPlayer(playerItem: playerItem)
        self.avPlay = play1
        let videoPlay = AVPlayerLayer(player: play1)
        videoPlay.videoGravity = AVLayerVideoGravity.resizeAspect
        videoPlay.frame = self.bounds
        self.layer.insertSublayer(videoPlay, above: self.layer)
        play1.play()
    }
    
    /** 监听 */
    fileprivate func addPlayNotification(){
        //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
        self.avPlay?.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.old, context: nil)
        //监控播放完成通知
        NotificationCenter.default.addObserver(self, selector: #selector(playbackFinished(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc fileprivate func playbackFinished(_ notifi:Notification){
        avPlay?.pause()
        delegate?.playVideoSuccess()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    // =========== @IBAction Method ============
    @IBAction func cancelBtnEvent(_ sender: UIButton) {
        if cancelBlock != nil {
            cancelBlock?()
        }
    }
}
