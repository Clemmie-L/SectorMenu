# SectorMenu
Sector Menu（扇形菜单）是一种‌环形布局的交互控件‌，通过动态展开子菜单项形成扇形或圆弧形界面。

## Image

![image](https://github.com/Clemmie-L/SectorMenu/blob/main/image/IMG_1.PNG)
![image](https://github.com/Clemmie-L/SectorMenu/blob/main/image/IMG_2.PNG)

## 使用方式

pod 'SectorMeun'

### 初始化

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

## 版本描述
### 1.0.0 初始版
