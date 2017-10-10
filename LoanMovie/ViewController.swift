//
//  ViewController.swift
//  LoanMovie
//
//  Created by maiGit on 2017/9/3.
//  Copyright © 2017年 maiGit. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    fileprivate let videoAuthStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    fileprivate let audioAuthStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func cameraBtnEvent(_ sender: UIButton) {
        if videoAuthStatus == AVAuthorizationStatus.authorized {//获取权限
            let videoVC = VideoCameraViewController()
            self.present(videoVC, animated: true, completion: nil)
        }else{
            if videoAuthStatus == AVAuthorizationStatus.notDetermined {
                _ = AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {(isInput) in
                    DispatchQueue.main.async {
                        let videoVC = VideoCameraViewController()
                        self.present(videoVC, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

