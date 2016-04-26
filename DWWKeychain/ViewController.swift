//
//  ViewController.swift
//  DWWKeychain
//
//  Created by redhat' iMac on 16/4/26.
//  Copyright © 2016年 Egeio. All rights reserved.
//

import UIKit
var VERSION = "1.1";  // 版本
var SALTSTR = "QwErTyUiOpLkJhGfDsAzXcVbNm<>()" ; // 自定义盐值，单机使用建议自行修改
class ViewController: UIViewController {

    @IBOutlet weak var siteNameLabel: UITextField!
    @IBOutlet weak var mycipherField: UITextField!
    @IBOutlet weak var bit8PWD: UILabel!
    @IBOutlet weak var bit14PWD: UILabel!
    @IBOutlet weak var bit20PWD: UILabel!
    @IBOutlet weak var anwserPanel: UIView!
    func GeneratePassword(superpass :String, length :Int) -> String{
        let upSuperpass = superpass.uppercaseString
        let start = Int(ceil(Float(length) / 2.0))
        var temppass = [String]() ;      // 临时字母表
        var DigitalCount   = 0 ; // 临时字母表中数字的个数
        for i in 0..<length{
            if(upSuperpass[i + start] <= "9" && superpass[i + start] >= "0")
            {
                // 包含数字
                DigitalCount += 1 ;
            }
            if((i + start) % 2 == 0){
                let str = upSuperpass[i + start].lowercaseString
                temppass.append(str)
            }
            else{
                temppass.append(upSuperpass[i + start] as String)
            }
        }
        return temppass.joinWithSeparator("")
    }
    
    
    func MyCrypt20121016(version :String, salt :String, v_sitename :String, v_mycipher :String) -> String {
        let md51 = (salt + v_sitename).md5
        let md52 = (salt + v_mycipher).md5
        let md53 = (md51 + salt + md52).md5
        let md54 = (md53 + salt).md5
        let base64str = md54.base64
        print("base64:" + base64str)
        return base64str
    }
    
    func CreateSuperPWD(siteName :String, mycipher :String) -> String{
       return MyCrypt20121016(VERSION, salt: SALTSTR, v_sitename: siteName, v_mycipher: mycipher)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        anwserPanel.hidden = true
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidEnterBackgroundNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (n ) in
            self.anwserPanel.hidden = true
        }
        
    }

    
    @IBAction func generatePWD(sender: AnyObject) {
        let superpassword = CreateSuperPWD(siteNameLabel.text!, mycipher: mycipherField.text!)
        let pwd8 = GeneratePassword(superpassword, length: 8)
        let pwd14 = GeneratePassword(superpassword, length: 14)
        let pwd20 = GeneratePassword(superpassword, length: 20)
        
        print("pwd 8:\(pwd8)")
        print("pwd 14:\(pwd14)")
        print("pwd 20:\(pwd20)")
        bit8PWD.text = pwd8
        bit14PWD.text = pwd14
        bit20PWD.text = pwd20
        anwserPanel.hidden = false
        self.view.endEditing(true)

    }
    @IBAction func copy8bitPWD(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = bit8PWD.text;
        SVProgressHUD.showSuccessWithStatus("复制成功")
    }
    @IBAction func copy14bitPWD(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = bit14PWD.text;
        SVProgressHUD.showSuccessWithStatus("复制成功")

    }
    @IBAction func copy20bitPWD(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = bit20PWD.text;
        SVProgressHUD.showSuccessWithStatus("复制成功")

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

