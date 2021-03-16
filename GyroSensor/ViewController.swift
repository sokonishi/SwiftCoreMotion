//
//  ViewController.swift
//  GyroSensor
//
//  Created by 小西壮 on 2021/03/08.
//

import UIKit
import CoreMotion
import AudioToolbox

class ViewController: UIViewController {
    
    private let motionManager = CMMotionManager()
    
    //高さ方向(絶対値が90を超えるとだめ)
    @IBOutlet weak var pitchLabel: UILabel!
    //幅方向(絶対値が90を超えるとだめ)
    @IBOutlet weak var rollLabel: UILabel!
    //水平(使わない)
    @IBOutlet weak var yawLabel: UILabel!
    
    @IBOutlet weak var countTimeLabel: UILabel!
    var countTime = 0

    @IBOutlet weak var picthColor: UILabel!
    @IBOutlet weak var rollColor: UILabel!
    
    @Published var soundID: SystemSoundID = 1151
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard motionManager.isDeviceMotionAvailable else { return }

    }
    
    // センサー取得を止める場合
    func stopAccelerometer(){
        if (motionManager.isDeviceMotionActive) {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    func applicationDidEnterBackground(){
        
        print("enterbackground")
        WKExtention
        
    }
    
    func attitude() {
        
        motionManager.deviceMotionUpdateInterval = 2 / 1
        
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.current!, withHandler: { [weak self] (motion, error) in
            guard let motion = motion, error == nil else { return }
//            guard let strongSelf = self else { return }


            let pitchAngle = motion.attitude.pitch * 180 / Double.pi
            let rollAngle = motion.attitude.roll * 180 / Double.pi
            let yawAngle = motion.attitude.yaw * 180 / Double.pi
            
            
            self?.pitchLabel.text = String(pitchAngle)
            self?.rollLabel.text = String(rollAngle)
            self?.yawLabel.text = String(yawAngle)
            
            if abs(pitchAngle) >= 90{
                self?.picthColor.backgroundColor = UIColor.red
            } else {
                self?.picthColor.backgroundColor = UIColor.blue
            }
            
            if abs(rollAngle) >= 90{
                self?.rollColor.backgroundColor = UIColor.red
                self?.countTime += 1
                self?.countTimeLabel.text = String(self!.countTime)
                //アラーム音を鳴らす
                AudioServicesPlayAlertSoundWithCompletion(self!.soundID, nil)
                //バイブレーションを作動させる
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
            } else {
                self?.countTime = 0
                self?.rollColor.backgroundColor = UIColor.blue
                self?.countTimeLabel.text = String(self!.countTime)
            }
            
        })
        
    }
    
    @IBAction func startButton(_ sender: Any) {
        
        attitude()
        
    }
    
    @IBAction func stopButton(_ sender: Any) {
        
        stopAccelerometer()
        
    }
    
}

