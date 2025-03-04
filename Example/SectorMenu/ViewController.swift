//
//  ViewController.swift
//  SectorMenu
//
//  Created by Clemmie on 03/04/2025.
//  Copyright (c) 2025 Clemmie. All rights reserved.
//

import UIKit
import SectorMenu

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建菜单配置
        let configs: [SectorConfig] = [
            SectorConfig(
                icon: UIImage(systemName: "plus")!,
                title: "添加",
                color: randomColor()
            ),
            SectorConfig(
                icon: UIImage(systemName: "trash")!,
                title: "删除",
                color: randomColor()
            ),
            SectorConfig(
                icon: UIImage(systemName: "pencil")!,
                title: "编辑",
                color: randomColor()
            ),
            SectorConfig(
                icon: UIImage(systemName: "square.and.arrow.up")!,
                title: "分享",
                color: randomColor()
            ),
            SectorConfig(
                icon: UIImage(systemName: "star")!,
                title: "收藏",
                color: randomColor()
            )
        ]
        
        // 创建圆形菜单视图
        let menuSize = CGSize(width: 360, height: 360)
        let menuOrigin = CGPoint(
            x: (view.bounds.width - menuSize.width) / 2,
            y: (view.bounds.height - menuSize.height) / 2
        )
        
        let menuFrame = CGRect(origin: menuOrigin, size: menuSize)
        
        // innerRadius 修改数值，更改扇形的样式。
        let menuView = SectorMenuView(frame: menuFrame, configs: configs, menuConfig: .init(innerRadius: 50))
        
        // 点击
        menuView.onSectorTap = { index in
            print(index)
        }
        // 添加菜单到视图层级
        view.addSubview(menuView)
        
    }
    
    func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        let randomColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return randomColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

