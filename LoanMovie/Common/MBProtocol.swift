//
//  MBProtocol.swift
//  LoanMovie
//
//  Created by maiGit on 2017/9/30.
//  Copyright © 2017年 maiGit. All rights reserved.
//

import Foundation

public protocol MBProtocolDelegate : NSObjectProtocol {
    /** 倒计时完成时时调用 */
    func countdownSuccess()
    /** 倒计时开始时调用 */
    func countdownBegin()
    /** 视频播放完成 */
    func playVideoSuccess()
    /** 重新朗读 */
    func readAloudAgain()
    /** 确认无误 */
    func confirmationIsCorrect()
    /** 返回 */
    func backItemSuccess()
}
