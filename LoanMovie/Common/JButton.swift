//
//  JButton.swift
//  LoanMovie
//
//  Created by maiGit on 2017/9/28.
//  Copyright © 2017年 maiGit. All rights reserved.
//

import UIKit

class JButton: UIButton {
    /// 倒计时 12 秒
    fileprivate var durations: Int = 12
    /// 定义计时器对象
    fileprivate var coustomTimer: Timer?
    
    /// 开启按钮倒计时
    var isDownTimer: Bool = false {
        willSet {
            if newValue { // newValue 参数在 赋值之前调用, 为 true 则开启计时器
                coustomTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addStartTimer), userInfo: nil, repeats: true)
                remainingSeconds = durations
            } else {
                coustomTimer?.invalidate()
                coustomTimer = nil
            }
        }
    }
    
    var remainingSeconds: Int = 0 {
        willSet {
            setTitle("\(newValue)秒完成", for: UIControlState())
            if newValue <= 1 {
                isDownTimer = false
                //倒计时已经完成，自动完成朗读且跳转视频录制播放界面
                self.timerSuccess()
            }
        }
    }
    
    private func timerSuccess() {
        NotificationCenter.default.post(name: NSNotification.Name("TIMERSUCCESSNOTIFICATION"), object: nil)
    }
    
    @objc fileprivate func addStartTimer() {
        remainingSeconds -= 1
    }
}
