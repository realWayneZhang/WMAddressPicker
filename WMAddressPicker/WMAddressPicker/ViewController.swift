//
//  ViewController.swift
//  WMAddressPicker
//
//  Created by Winson Zhang on 2018/12/27.
//  Copyright © 2018 Winson. All rights reserved.
//

import UIKit

/*
 WMAddressPicker 需依赖 HandyJSON 和 IBAnimatable 两个第三方库，
 前者不必说，但凡 Swift 项目，解析JSON格式网络数据，HandyJSON 必备，给阿里打个小小广告 😂
 后者是个便捷，强大，简单，且是 ViewController 级的专场动画框架，添加这个库，项目事半功倍，给 APP 添加精彩奇妙的动画效果
 有兴趣的可以 Google 或百度一下。
 当然 你也可以自定义专场动画，来 Present WMAddressPicker，随你喜好
 */

class ViewController: UIViewController {
    @IBOutlet weak var addressLabel: UILabel!
    /// 懒加载
    lazy var addressPicker: WMAddressPicker = {
        let nib = UINib(nibName: "WMAddressPicker", bundle: nil)
        let picker = nib.instantiate(withOwner: nil, options: nil).first as! WMAddressPicker
        picker.modalSize = (width: .full, height: .threeQuarters)
        picker.modalPosition = .bottomCenter
        picker.cornerRadius = 10
        /// 该回调方法可以在本类任意地方写
        picker.selectedAreaCompleted = { [weak self] (province, city, district) in
            self?.addressLabel.text = province + " " + city + " " + district
        }
        return picker
    }()
    /// 调用
    @IBAction func selectButonClicked(_ sender: Any) {
        self.present(addressPicker, animated: true, completion: nil)
    }
}

