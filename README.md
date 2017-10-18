# LoanMovie
该项目是一款依据AVFounation库搭载的视频录制以及播放功能的Demo.

Xcode9.0
Swift4.0

  定义 相机，麦克风权限
    fileprivate let videoAuthStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    fileprivate let audioAuthStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
    
 根据用户响应权限状态做出相应的处理
 
    if videoAuthStatus == AVAuthorizationStatus.authorized {
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
        
 demo里面的文字几乎不涉及到文字排版处理，demo直接采用瀑布流处理，每一个Cell即一个文字和拼音；
 所以动画处理实际是对瀑布流的每个cell进行动画操作；
 
 文字渐变部分：
    
    ①. 添加基础动画CABasicAnimation
    ②. demo用CALayer基础图层进行动画
            
 具体效果详见代码。
 demo中文字渐变最主要的处理是将动画在图层 mask 属性上面处理，相信 mask 对于我们是非常熟悉的。
 当需要删除动画，我们可将 mask = nil 就会删除之前执行的动画
 
 demo中关于文字处理部分，是根据文字的跑马灯效果获得的灵感，demo中关于文字的处理效果并不是唯一的一种方式，大家有什么好的想法或者建议欢迎留言。
 

