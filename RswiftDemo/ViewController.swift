//
//  ViewController.swift
//  RswiftDemo
//
//  Created by HuangSenhui on 2020/2/25.
//  Copyright © 2020 HuangSenhui. All rights reserved.
//  国际化：storyboard: label、button、image ...

import UIKit

var appLanguage: [String] {
    get {
        UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
    }
    set {
        if let new = newValue.first {
            UserDefaults.standard.set([new], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            // Bundle
            object_setClass(Bundle.main, LocaleBundle.self)
            if let path = Bundle.main.path(forResource: newValue[0], ofType: "lproj") {
                let newBundle = Bundle(path: path)
                objc_setAssociatedObject(Bundle.main, &LocaleBundle.identifier, newBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        } else {
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var photoImagView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let langId = appLanguage
        let locl = NSLocale(localeIdentifier: langId[0])
        let langName = locl.displayName(forKey: NSLocale.Key.identifier, value: langId[0])!
        print("当前系统语言：\(langName)")
        // color
        codeLabel.textColor = R.color.yellow()
        // string
        codeLabel.text = R.string.localizable.应用语言() + ":\(langName)"
        // image
        // assets提供了本地化 (-- Version 11.3.1 (11C504) 无效  ？？？)
        photoImagView.image = R.image.home.xcodeIcon()
        
        
        // 1.1 替代方案，切换语言重置rootViewController 或者向每个 ViewController 发通知更新UI
        // 重写 bundle localizedString 方法
        // 使用 runtime 对象替换方法修改自定义Bundle
        
        // 2.storyboard 无法自动更新修改
        // 使用 ibtool + FileMerge 进行维护
        // 2.1 strings 也需要麻烦的维护多个文件
        
        // Todo:
        // 1.重启，更改语言 （暂时无找到app重启方案）
    }
    deinit {
        print(#function)
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
            appLanguage = [lanId]
            self.resetRootVC()
        }
        let lanId2 = langs[1]
        let locl2 = NSLocale(localeIdentifier: lanId2)
        let langName2 = locl2.displayName(forKey: NSLocale.Key.identifier, value: lanId2)!
        let lan2 = UIAlertAction(title: langName2, style: .default) { _ in
            appLanguage = [lanId2]
            self.resetRootVC()
        }
        
        let cancelAction = UIAlertAction(title: R.string.localizable.取消(), style: .cancel) { _ in
            // 跟随系统环境
//            appLanguage = []
//            let system = appLanguage
//            appLanguage = system
//            self.resetRootVC()
        }
        
        alertVC.addAction(lan)
        alertVC.addAction(lan2)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    func resetRootVC() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = R.storyboard.main.instantiateInitialViewController()
        }
    }
    
}

class LocaleBundle: Bundle {
    static var identifier = "LocaleBundle"
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let myBundle = objc_getAssociatedObject(self, &LocaleBundle.identifier) as? Bundle
        if let bundle = myBundle {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}
