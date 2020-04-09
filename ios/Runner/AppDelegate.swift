import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    
    var photoEditor:DSPhotoEditor!
    
  
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    self.photoEditor = DSPhotoEditor(controller: controller)
    let photoEditorChannel = FlutterMethodChannel(name: "ec.dina/ds-photo-editor", binaryMessenger: controller.binaryMessenger)
    photoEditorChannel.setMethodCallHandler({
        (call,result) -> Void in
        
          result(nil)
        
        if(call.method=="pick"){
            self.photoEditor.pick()
          
        }else{
            result(FlutterMethodNotImplemented)
        }
        
    })
    
    
    
    
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
