//: Playground - noun: a place where people can play

import UIKit
import SceneKit
import PlaygroundSupport

class Watch: UIView{
    
    var mainBackgroundXDimension = 0
    var mainBackgroundYDimension = 0
    var currentTime: Date {
        return Date()
    }
    
    var timer: Timer?
    var viewDivider  = true
    var weekDay = 1
    var dayDate = 1
    let weekDays = ["SUN", "MON", "TUE","WED", "THU", "FRI", "SAT"]
    
    let watchFaceWidth = 104
    let watchFaceHeight = 130
    let watchImageView = WatchView()
    var watchImageCenterX : CGFloat = 0
    var watchImageCenterY : CGFloat = 0
    var digitalTime : UILabel?
    var currentDate : UILabel?
    var planets = [String: UIImage]()
    
    let sceneView : SCNView?
    let scene  = SCNScene()
    let planetNode = SCNNode()
    
    public init(width : CGFloat, height : CGFloat){
        sceneView = SCNView(frame: CGRect(x:0,y:0,width:watchFaceWidth,height:watchFaceHeight))
        
        super.init(frame: CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height))
        
        mainBackgroundXDimension = Int(width)
        mainBackgroundYDimension = Int(height)
        setBackgroundColor()
        watchImageCenterX = watchImageView.frame.width/2 - 4
        watchImageCenterY = watchImageView.frame.height/2
        createWatchView()
        initializeDigitalTime()
        initializeCurrentDate()
        createPlanetsDictionary()
        initializePlanetScene()
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(updateTimeLabel),
            userInfo: nil,
            repeats: true)
    }
    func createWatchView (){
        self.addSubview(watchImageView)
        watchImageView.center = CGPoint(
            x: mainBackgroundXDimension/2,
            y: mainBackgroundYDimension/2)
        
    }
    func initializeDigitalTime(){
        digitalTime = UILabel(frame: CGRect(x: (0.6)*CGFloat(watchFaceWidth), y: (0.1)*CGFloat(watchFaceHeight), width: CGFloat(watchFaceWidth)/2,height: CGFloat(watchFaceHeight)/4))
        digitalTime?.font = UIFont(name: "HelveticaNeue", size: 20)
        digitalTime?.textColor = UIColor.white
        digitalTime?.text = "00:00"
    }
    func initializeCurrentDate(){
        currentDate = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat(watchFaceWidth)/2, height: CGFloat(watchFaceHeight)/5))
        currentDate?.text = "-- --"
        currentDate?.textColor = UIColor.white
        currentDate?.font = UIFont(name: "HelveticaNeue", size: 12)
    }
    func updateTimeLabel() {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let hour = Calendar.current.component(.hour, from: currentTime)
        let hourString : String = hour <= 9 ? "0\(hour)" : "\(hour)"
        let minute = Calendar.current.component(.minute, from: currentTime)
        let minuteString : String = minute <= 9 ? "0\(minute)" : "\(minute)"
        weekDay = Calendar.current.component(.weekday, from: currentTime)
        dayDate = Calendar.current.component(.day, from :currentTime)
        if viewDivider{
            digitalTime?.text = "\(hourString):\(minuteString)"
            viewDivider = false
        }
        else{
            digitalTime?.text = "\(hourString) \(minuteString)"
            viewDivider = true
        }
        currentDate?.text = "\(weekDays[weekDay-1]) \(dayDate)"
    }
    func createPlanetsDictionary(){
        planets["earth"] = UIImage(named: "earth.jpg")
        planets["mars"] = UIImage(named: "mars.jpg")
        planets["jupiter"] = UIImage(named:"jupiter.jpg")
        planets["neptune"] = UIImage(named: "neptune.jpg")

    }
    func initializePlanetScene(){
        sceneView?.scene = scene
        sceneView?.backgroundColor = UIColor.black
        sceneView?.autoenablesDefaultLighting = true
        watchImageView.addSubview(sceneView!)
        sceneView?.center = CGPoint(
            x: watchImageCenterX,
            y:watchImageCenterY)
        planetNode.geometry = SCNSphere(radius: 1)
        planetNode.geometry?.firstMaterial?.diffuse.contents = planets["neptune"]
        planetNode.geometry?.firstMaterial?.isDoubleSided = true
        scene.rootNode.addChildNode(planetNode)
        let action = SCNAction.rotate(by: 360*CGFloat((M_PI)/180.0), around:SCNVector3Make(0, 2, 0), duration: 8)
        let repeatAction = SCNAction.repeatForever(action)
        planetNode.runAction(repeatAction)
        sceneView?.addSubview(currentDate!)
        sceneView?.addSubview(digitalTime!)

    }
    func setBackgroundColor(){
        let bc = CAGradientLayer()
        let topColor = UIColor(colorLiteralRed: 0.325, green: 0.824, blue: 0.675, alpha: 1.00).cgColor
        let bottomColor = UIColor(colorLiteralRed: 0.129, green: 0.412, blue: 0.647, alpha: 1.00).cgColor
        bc.colors = [topColor, bottomColor]
        bc.locations = [0.0, 1.0]
        bc.frame = self.bounds
        bc.zPosition = -1
        self.layer.insertSublayer(bc, at: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let mainBackgroundYDimension = 500
let mainBackgroundXDimension = 1000
let mainBackground = Watch(width: CGFloat(mainBackgroundXDimension), height: CGFloat(mainBackgroundYDimension))

PlaygroundPage.current.liveView = mainBackground