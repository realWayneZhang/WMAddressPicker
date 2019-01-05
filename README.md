# WMAddressPicker
## 仿京东、淘宝地址选择器
![示例gif](https://github.com/WinsonCheung/WMAddressPicker/blob/master/WMAddressPicker.gif)

## 说明
需依赖 HandyJSON（用于解析地址 json 数据） 和 IBAnimatable（模态控制器），如果不想导入 IBAnimatable，可自行写模态转场动画
（IBAnimatable 框架的强大，超乎你的想象）

## 使用
```swift
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
```

### 有需要的猿类可以参考或使用，如果对你有帮助，甚感欣慰～ Thank you for look！
