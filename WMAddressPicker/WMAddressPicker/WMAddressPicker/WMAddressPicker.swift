//
//  YMAreaController.swift
//  RefuelNow
//
//  Created by Winson Zhang on 2018/12/19.
//  Copyright © 2018 LY. All rights reserved.
//

import UIKit
import IBAnimatable

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

enum TableViewType: Int { case province = 100, city = 200, distrcit = 300 }

fileprivate let provinceCellId = "provinceCell"
fileprivate let cityCellId = "cityCell"
fileprivate let districtCellId = "districtCell"

class WMAddressPicker: AnimatableModalViewController {
    @IBOutlet weak var scrollViewHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var provinceButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var districtButton: UIButton!
    fileprivate var buttons: [UIButton] = []
    fileprivate var province_tb: UITableView?
    fileprivate var city_tb: UITableView?
    fileprivate var district_tb: UITableView?
    fileprivate var provinces: [Province] = []
    fileprivate var cities: [City] = []
    fileprivate var districts: [District] = []
    fileprivate var provinceSelIndexPath: IndexPath?
    fileprivate var citySelIndexPath: IndexPath?
    fileprivate var districtSeIndexPath: IndexPath?
    
    fileprivate var sel_province: String = "" {
        didSet {
            provinceButton.setTitle(sel_province, for: UIControl.State.normal)
            cityButton.setTitle("请选择", for: UIControl.State.normal)
            districtButton.setTitle(nil, for: UIControl.State.normal)
        }
    }
    
    fileprivate var sel_city: String = "" {
        didSet {
            cityButton.setTitle(sel_city, for: UIControl.State.normal)
            districtButton.setTitle("请选择", for: UIControl.State.normal)
        }
    }
    
    fileprivate var sel_district: String = "" {
        didSet {
            districtButton.setTitle(sel_district, for: UIControl.State.normal)
        }
    }
    typealias AreaAction = ((_ province: String, _ city: String, _ district: String) -> Void)?
    
    var selectedAreaCompleted: AreaAction


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
}

extension WMAddressPicker {
    fileprivate func setupUI() {
        setupTalbeView()
        setupButtons()
    }
    fileprivate func setupTalbeView() {
        scrollView.delegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        province_tb = factoryTableView(type: .province, cellIdentifier: provinceCellId)
        scrollView.addSubview(province_tb!)
        city_tb = factoryTableView(type: .city, cellIdentifier: cityCellId)
        scrollView.addSubview(city_tb!)
        district_tb = factoryTableView(type: .distrcit, cellIdentifier: districtCellId)
        scrollView.addSubview(district_tb!)
    }
    
    fileprivate func setupButtons() {
        provinceButton.isSelected = true
        buttons = [provinceButton, cityButton, districtButton]
        _ = buttons.map {
            $0.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            $0.setTitleColor(UIColor.black, for: UIControl.State.selected)
        }
    }
}

extension WMAddressPicker {
    fileprivate func loadData() {
        
        let path = Bundle.main.path(forResource: "divisions.json", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        let jsonData = Data(referencing: data!)
        let json = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [Any]
        guard let jsonArray = json else { return }
        provinces = [Province].deserialize(from: jsonArray)! as! [Province]
        province_tb?.reloadData()
    }
}

extension WMAddressPicker: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = TableViewType(rawValue: tableView.tag)!
        switch type {
        case .province:
            return provinces.count
        case .city:
            return cities.count
        case .distrcit:
            return districts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = TableViewType(rawValue: tableView.tag)!
        switch type {
            
        case .province:
            let cell = tableView.dequeueReusableCell(withIdentifier: provinceCellId, for: indexPath) as! WMAddressCell
                cell.nameLabel?.text = provinces[indexPath.row].name
                cell.isSelect = indexPath == provinceSelIndexPath
            return cell
            
        case .city:
            let cell = tableView.dequeueReusableCell(withIdentifier: cityCellId, for: indexPath) as! WMAddressCell
            cell.nameLabel?.text = cities[indexPath.row].name
            cell.isSelect = indexPath == citySelIndexPath
            return cell
            
        case .distrcit:
            let cell = tableView.dequeueReusableCell(withIdentifier: districtCellId, for: indexPath) as! WMAddressCell
            if districts.count > 0 {
                cell.nameLabel?.text = districts[indexPath.row].name
                cell.isSelect = indexPath == districtSeIndexPath
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = TableViewType(rawValue: tableView.tag)!
        switch type {
            
        case .province:
            if let provinceSelIndexPath = provinceSelIndexPath {
                let cell = tableView.cellForRow(at: provinceSelIndexPath) as? WMAddressCell
                cell?.isSelect = false
                if provinceSelIndexPath != indexPath {
                    citySelIndexPath = nil
                    districtSeIndexPath = nil
                }
            }
            provinceSelIndexPath = indexPath
            self.sel_province = self.provinces[indexPath.row].name
            let cell = tableView.cellForRow(at: indexPath) as! WMAddressCell
            cell.isSelect = true
            cities = provinces[indexPath.row].cities
            scrollView.contentSize = CGSize(width: ScreenWidth * 2, height: scrollViewHeight)
            city_tb?.reloadData()
            scrollView.setContentOffset(CGPoint(x: ScreenWidth, y: 0), animated: true)
            
        case .city:
            if let citySelIndexPath = citySelIndexPath {
                let cell = tableView.cellForRow(at: citySelIndexPath) as? WMAddressCell
                cell?.isSelect = false
                if citySelIndexPath != indexPath { districtSeIndexPath = nil }
            }
            citySelIndexPath = indexPath
            self.sel_city = self.cities[indexPath.row].name
            let cell = tableView.cellForRow(at: indexPath) as! WMAddressCell
            cell.isSelect = true
            districts = cities[indexPath.row].districts
            if districts.count > 0 {
                scrollView.contentSize = CGSize(width: ScreenWidth * 3, height: scrollViewHeight)
                district_tb?.reloadData()
                scrollView.setContentOffset(CGPoint(x: ScreenWidth * 2, y: 0), animated: true)
            } else {
                selectedAreaCompleted?(sel_province, sel_city, sel_district)
                dismissButtonClicked()
            }
            
        case .distrcit:
            if let districtSeIndexPath = districtSeIndexPath {
                let cell = tableView.cellForRow(at: districtSeIndexPath) as? WMAddressCell
                cell?.isSelect = false
            }
            districtSeIndexPath = indexPath
            let cell = tableView.cellForRow(at: indexPath) as! WMAddressCell
            cell.isSelect = true
            sel_district = districts[indexPath.row].name
            selectedAreaCompleted?(sel_province, sel_city, sel_district)
            dismissButtonClicked()
        }
    }
}

extension WMAddressPicker {
    @IBAction func dismissButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func areaButtonClicked(_ sender: UIButton) {
        
       let type = TableViewType(rawValue: sender.tag)
        switch type! {
            case .province: scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            case .city: scrollView.setContentOffset(CGPoint(x: ScreenWidth, y: 0), animated: true)
            case .distrcit: scrollView.setContentOffset(CGPoint(x: ScreenWidth * 2, y: 0), animated: true)
        }
    }
}

extension WMAddressPicker {
    
    fileprivate func factoryTableView(type: TableViewType, cellIdentifier: String) -> UITableView {
        let tb = UITableView(frame: tbFrame, style: UITableView.Style.plain)
        tb.register(UINib.init(nibName: "WMAddressCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        if #available(iOS 11.0, *) { tb.contentInsetAdjustmentBehavior = .never }
        else { self.automaticallyAdjustsScrollViewInsets = false }
        tb.separatorStyle = UITableViewCell.SeparatorStyle.none
        tb.tableHeaderView = UIView()
        tb.tableFooterView = UIView()
        tb.tag = type.rawValue
        tb.dataSource = self
        tb.delegate = self
        tb.rowHeight = 44
        var frame = tb.frame
        switch type {
        case .province: frame.origin.x = 0
        case .city: frame.origin.x = ScreenWidth
        case .distrcit: frame.origin.x = ScreenWidth * 2
        }
        tb.frame = frame
        return tb
    }
}

extension WMAddressPicker {

    var scrollViewHeight: CGFloat {
        // 适配 iPhoneX 及以上 底部的安全区域，可根据项目中实际 tabBar 的高度适配
//        let mainVC = UIApplication.shared.delegate?.window??.rootViewController as! MainTabbarController
//        return ScreenHeight * 3 / 4 - 70 - (mainVC.tabBar.frame.height - 49)
        return ScreenHeight * 3 / 4 - 70 - (ScreenHeight >= 812 ? 34 : 0)
    }
    var tbFrame: CGRect {  return CGRect(x: 0, y: 0, width: ScreenWidth, height: scrollViewHeight) }
}


extension WMAddressPicker: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if  scrollView.tag != 0 { return }
        _ = buttons.map { $0.isSelected = false }
        if scrollView.contentOffset.x == 0 { provinceButton.isSelected = true }
        if scrollView.contentOffset.x == ScreenWidth { cityButton.isSelected = true }
        if scrollView.contentOffset.x == ScreenWidth * 2  { districtButton.isSelected = true }
    }
}

extension WMAddressPicker {
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.scrollViewHeightConstaint.constant = scrollViewHeight
    }
}
