//
//  ViewController.swift
//  RswiftDemo
//
//  Created by HuangSenhui on 2020/2/25.
//  Copyright © 2020 HuangSenhui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var photoImagView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // 当前手机语言
        // AppleLanguages 未设置时跟随系统语言
        // 设置后，需重启应用才生效
        let langId = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        let locl = NSLocale(localeIdentifier: langId.first!)
        let langName = locl.displayName(forKey: NSLocale.Key.identifier, value: langId.first!)!
        
        // color
        codeLabel.textColor = R.color.yellow()
        // string
        codeLabel.text = R.string.localizable.系统语言() + ":\(langName)"
        // image
        // assets提供了本地化
        photoImagView.image = R.image.xcodeIcon()
        
        // Todo:
        // 1.不重启，更改语言
        // 2.storyboard 无法自动更新修改
        
    }

    @IBAction func changeLanguage(_ sender: UIButton) {
        
        // app可用语言
        var langs = Bundle.main.localizations
        if let baseIndex = langs.firstIndex(of: "Base") {
            langs.remove(at: baseIndex)
        }
        
        let alertVC = UIAlertController(title: R.string.localizable.多语言(), message: nil, preferredStyle: .actionSheet)
        
        let lanId = langs[0]
        let locl = NSLocale(localeIdentifier: lanId)
        let langName = locl.displayName(forKey: NSLocale.Key.identifier, value: lanId)!
        let lan = UIAlertAction(title: langName, style: .default) { _ in
            UserDefaults.standard.set([lanId], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
        let lanId2 = langs[1]
        let locl2 = NSLocale(localeIdentifier: lanId2)
        let langName2 = locl2.displayName(forKey: NSLocale.Key.identifier, value: lanId2)!
        let lan2 = UIAlertAction(title: langName2, style: .default) { _ in
            UserDefaults.standard.set([lanId2], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
        
        let cancelAction = UIAlertAction(title: R.string.localizable.取消(), style: .cancel, handler: nil)
        alertVC.addAction(lan)
        alertVC.addAction(lan2)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
}

