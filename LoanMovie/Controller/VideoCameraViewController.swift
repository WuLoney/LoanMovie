//
//  VideoCameraViewController.swift
//  LoanMovie
//
//  Created by maiGit on 2017/9/6.
//  Copyright © 2017年 maiGit. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCameraViewController: UIViewController {
    
    private lazy var fullView: VideoHeaderView = {
        let view = Bundle.main.loadNibNamed("VideoHeaderView", owner: self, options: nil)?.first as!VideoHeaderView
        return view
    }()
    
    private lazy var footerView: MBFullView = {
        let view = Bundle.main.loadNibNamed("MBFullView", owner: self, options: nil)?.first as! MBFullView
        return view
    }()
    
    private lazy var successView: MBSuccessView = {
        let view = Bundle.main.loadNibNamed("MBSuccessView", owner: self, options: nil)?.first as! MBSuccessView
        view.delegate = self
        return view
    }()
    
    fileprivate var smallView: MBSmallView = {
        let view = MBSmallView.init(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    
    /// 容器
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        if session.canSetSessionPreset(AVCaptureSession.Preset.vga640x480) {
            session.sessionPreset = AVCaptureSession.Preset.vga640x480
        }
        return session
    }()
    /// 视频设备
    private var videoDevices: AVCaptureDevice?
    /// 音频设备
    private var audioDevices: AVCaptureDevice?
    /// 视频输入流
    private var videoCaptureInput: AVCaptureDeviceInput?
    /// 音频输入流
    private var audioCaptureInput: AVCaptureDeviceInput?
    /// 视频+音频文件输出流
    private var fileCaptrueOutput: AVCaptureMovieFileOutput?
    /// 视频捕捉图层
    private var captureVideoLayer: AVCaptureVideoPreviewLayer?
    /// 导出的视频路径
    var currentMoviePath:String = ""
    /// 是否开始朗读
    var isStartRead: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(fullView)
        initOptionDevice()
        addCaptureDevice()
        getVideoSaveFilePathString()
        view.addSubview(footerView)
        view.addSubview(self.smallView)
        actionBlockSetMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(stopTimerAction(_:)), name: NSNotification.Name("TIMERSUCCESSNOTIFICATION"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: UIApplication.shared)
        captureSession.startRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fullView.startCellTextAnimations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("TIMERSUCCESSNOTIFICATION"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: UIApplication.shared)
        fullView.stopCellTextAnimations()
        captureSession.stopRunning()
    }
    
    /// 隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        fullView.frame = CGRect(x:0,
                                y:0,
                                width:view.bounds.width,
                                height:view.bounds.width * 0.5)
        
        captureVideoLayer?.frame = CGRect(x:0,
                                          y:fullView.frame.maxY,
                                          width:view.frame.width,
                                          height:view.frame.height - fullView.frame.maxY)
        
        footerView.frame = (captureVideoLayer?.frame)!
        
        smallView.frame = CGRect(x:view.frame.width,
                                 y:0,
                                 width:view.frame.width,
                                 height:view.frame.height)
    }
    
    @objc fileprivate func stopTimerAction(_ noti: Notification) {
        if self.isStartRead {
            // 停止录制
            self.stopVideoRecorder()
        }
    }
    
    @objc private func applicationDidEnterBackground(_ notification: NSNotification) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func initOptionDevice() {
        videoDevices = getCameraFront(AVCaptureDevice.Position.front)
        audioDevices = AVCaptureDevice.default(for: .audio)
        do {
            videoCaptureInput = try AVCaptureDeviceInput(device: videoDevices!)
            audioCaptureInput = try AVCaptureDeviceInput(device: audioDevices!)
        } catch  {}
        fileCaptrueOutput = AVCaptureMovieFileOutput()
        // 初始化显示图层
        captureVideoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        captureVideoLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(captureVideoLayer!)
    }
    
    /// get 到所有摄像头中的前置摄像头
    private func getCameraFront(_ position: AVCaptureDevice.Position)->AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: .video)
        for (_, device) in devices.enumerated() {
            // 判断设备是否支持 position 方向
            if device.position == position {
                // 判断设备是否支持 640 * 480 分辨率
                if device.supportsSessionPreset(AVCaptureSession.Preset.vga640x480) {
                    return device
                }
                return device
            }
        }
        return devices.first
    }
    
    private func addCaptureDevice() {
        if captureSession.canAddInput(videoCaptureInput!) && captureSession.canAddInput(audioCaptureInput!) {
            captureSession.addInput(videoCaptureInput!)
            captureSession.addInput(audioCaptureInput!)
            
            //根据设备输出获得连接
            let captureConnection = fileCaptrueOutput?.connection(with: AVMediaType.video)
            //是否支持光学防抖
            if (videoDevices?.activeFormat.isVideoStabilizationModeSupported(AVCaptureVideoStabilizationMode.cinematic))! {
                captureConnection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.cinematic
            }
        }
        
        if captureSession.canAddOutput(fileCaptrueOutput!) {
            captureSession.addOutput(fileCaptrueOutput!)
        }
    }
    
    /// 视频存放路径
    fileprivate func getVideoSaveFilePathString() {
        // 获取沙盒目录下的Documents路径
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileManager = FileManager.default
        let isDirExist: Bool = fileManager.fileExists(atPath: paths!)
        // 路径文件不存在，则创建
        if (!(isDirExist)) {
            do {
                try fileManager.createDirectory(atPath: paths!, withIntermediateDirectories: true, attributes: nil)
            } catch{}
        }
        let path = paths?.appending("/video.mov")
        self.currentMoviePath = path!
    }
    
    ///开始录制
    fileprivate func startVideoRecorder(){
        let movieConnection = fileCaptrueOutput?.connection(with: AVMediaType.video)
        movieConnection?.videoOrientation = AVCaptureVideoOrientation.portrait
        movieConnection?.videoScaleAndCropFactor = 1.0
        //设备没有做输出连接
        if !((fileCaptrueOutput?.isRecording)!) {
            //预览图层和视频方向保持一致
            movieConnection?.videoOrientation = (captureVideoLayer?.connection?.videoOrientation)!
            fileCaptrueOutput?.startRecording(to: URL(fileURLWithPath: self.currentMoviePath), recordingDelegate: self)
        }
    }
    
    ///结束录制
    fileprivate func stopVideoRecorder(){
        if (fileCaptrueOutput?.isRecording)! {
            //停止录制
            fileCaptrueOutput?.stopRecording()
        }
    }
    
    /// MARK: Action Block Set Method
    private func actionBlockSetMethod() {
        // 取消
        footerView.cancelBlock = { () in
            self.dismiss(animated: true, completion: nil)
        }
        // 开始朗读
        fullView.startAction = { () in
            if self.isStartRead {
                // 停止录制
                self.stopVideoRecorder()
            } else {
                UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions.calculationModeLinear, animations: {
                    self.smallView.frame.origin = CGPoint(x:0,
                                                          y:0)
                }, completion: { (isBool) in
                    //动画执行完成，启动计时器
                    self.smallView.playWithNumber(startNumber: 3, delegate: self)
                })
            }
        }
    }
}

extension VideoCameraViewController: MBProtocolDelegate {
    /// 倒计时开始时调用
    func countdownBegin() {
        fullView.stopCellTextAnimations()
        isStartRead = true
    }
    
    // 倒计时完成时调用
    func countdownSuccess() {
        smallView.removeFromSuperview()
        // 开始录制
        startVideoRecorder()
        fullView.successReadBtnAction()
    }
    // 视频播放完成
    func playVideoSuccess() {
        view.addSubview(successView)
        successView.frame = view.frame
    }
    // 重新朗读
    func readAloudAgain() {
        successView.removeFromSuperview()
        fullView.stopCellTextAnimations()
        footerView.layer.sublayers?.last?.removeFromSuperlayer()
        isStartRead = false
        fullView.playWriteVideoData(true)
    }
    // 确认无误
    func confirmationIsCorrect() {
        self.dismiss(animated: true, completion: nil)
    }
    // 返回
    func backItemSuccess() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension VideoCameraViewController:AVCaptureFileOutputRecordingDelegate {
    /// 当输出将停止向文件写入新样本时，通知委托人
    func fileOutput(_ captureOutput: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?){
        if error == nil {
            // TODO, 跳转录制视频播放界面
            if outputFileURL.isFileURL {
                fullView.playWriteVideoData(false)
                footerView.getRecordingCompleteVideo(outputFileURL, self)
            }
        }
    }
}
