//
//  XRLocalizableStringManager.swift
//
//  Copyright (c) 2018 - 2020 Ran Xu
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

let UDKEY_APP_CURRENT_SET_LANGUAGE: String = "UDKEY_APP_CURRENT_SET_LANGUAGE"

// 语言环境定义
enum XRSystemLanaguageType: String {
    case en_us = "en.lproj" // 英文环境
    case zh_cn = "zh-Hans.lproj" // 中文环境
}

class XRLocalizableStringManager: NSObject {

    // MARK: - 获取当前系统语言环境
    static func currentSystemLanguageType() -> XRSystemLanaguageType {
        
        var languageType: XRSystemLanaguageType = .zh_cn
        
        // 先取系统首选语言
        if let appLanguages = UserDefaults.standard.value(forKey: "AppleLanguages") as? [String] {
            if let currentLanguage = appLanguages.first {
                if currentLanguage.hasPrefix("en") {
                    // 英文环境
                    languageType = .en_us
                }
                else if currentLanguage.hasPrefix("zh") {
                    // 中文环境 (简体，繁体)，目前没有考虑繁体，繁体时显示的是英文
                    languageType = .zh_cn
                }
            }
        }
        
        // 再取用户设置的语言
        if let languageValue = UserDefaults.standard.value(forKey: UDKEY_APP_CURRENT_SET_LANGUAGE) as? String {
            if languageValue == XRSystemLanaguageType.en_us.rawValue {
                languageType = .en_us
            }
            else if languageValue == XRSystemLanaguageType.zh_cn.rawValue {
                languageType = .zh_cn
            }
        }
        
        return languageType
    }
    
    /** 返回国际化字符串
     -  根据系统语言返回对应的国际化字符串
     */
    static func localizableStringFromKey(key: String) -> String {
        
        let localizableString = NSLocalizedString(key, comment: "")
        return localizableString
    }
    
    /** 返回指定table的国际化字符串
     - key 国际化字符串 key
     - 手动切换App语言
     */
    static func localizableStringFromTableHandle(key: String) -> String {
        
        var localizableString: String = ""
        
        // 首先取当前系统语言环境
        var curLanguageType: String = self.currentSystemLanguageType().rawValue
        
        // 再取用户设置的语言环境，若没有设置即第一次打开App，则跟随系统语言环境
        if let curLanguage = UserDefaults.standard.value(forKey: UDKEY_APP_CURRENT_SET_LANGUAGE) as? String {
            curLanguageType = curLanguage
        }
        
        if let path = Bundle.main.path(forResource: curLanguageType, ofType: nil) , let theBundle = Bundle(path: path) {
            localizableString = theBundle.localizedString(forKey: key, value: nil, table: "Localizable")
        }
        
        return localizableString
    }
    
}
