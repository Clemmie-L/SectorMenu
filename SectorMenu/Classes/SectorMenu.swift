
import UIKit
import SnapKit

// MARK: - 扇形区域配置
public struct SectorConfig {
     let icon: UIImage?
     let title: String?
     let color: UIColor
     let spacing: CGFloat = 4
     let shadowColor: UIColor
     let shadowOffset: CGSize
     let shadowRadius: CGFloat
     let shadowOpacity: Float
    
    public init(icon: UIImage? = nil,
         title: String? = nil,
         color: UIColor = .systemBlue,
         shadowColor: UIColor = .clear,
         shadowOffset: CGSize = CGSize(width: 0, height: 0),
         shadowRadius: CGFloat = 0,
         shadowOpacity: Float = 0.0) {
        self.icon = icon
        self.title = title
        self.color = color
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
    }
}

// MARK: - 圆形菜单配置
public struct SectorMenuConfig {
    let innerRadius: CGFloat
    let centerButtonSize: CGFloat
    let centerButtonIcon: UIImage?
    let centerButtonColor: UIColor
    let animationDuration: TimeInterval
    let shadowRadius: CGFloat
    let shadowOpacity: Float
    
    public init(innerRadius: CGFloat = 50,
         centerButtonSize: CGFloat = 50,
         centerButtonIcon: UIImage? = UIImage(systemName: "xmark"),
         centerButtonColor: UIColor = .white,
         animationDuration: TimeInterval = 0.3,
         shadowRadius: CGFloat = 4,
         shadowOpacity: Float = 0.2) {
        self.innerRadius = innerRadius
        self.centerButtonSize = centerButtonSize
        self.centerButtonIcon = centerButtonIcon
        self.centerButtonColor = centerButtonColor
        self.animationDuration = animationDuration
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
    }
    
    public static let `default` = SectorMenuConfig()
}

public class SectorMenuView: UIView, UIGestureRecognizerDelegate {
    // 点击事件回调闭包
    public var onSectorTap: ((Int) -> Void)?
    
    private let centerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.clipsToBounds = true
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        button.tintColor = .darkGray
        return button
    }()
    
    private var sectors: [SectorView] = []
    private var configs: [SectorConfig] = []
    private var menuConfig: SectorMenuConfig
    private var isMenuExpanded = false
    
    // MARK: - 初始化
    public init(frame: CGRect, configs: [SectorConfig], menuConfig: SectorMenuConfig = .default) {
        self.configs = configs
        self.menuConfig = menuConfig
        super.init(frame: frame)
        setupUI()
        // 初始化时收起菜单
        sectors.forEach { $0.alpha = 0 }
    }
    
    required init?(coder: NSCoder) {
        self.menuConfig = .default
        super.init(coder: coder)
        setupUI()
        // 初始化时收起菜单
        sectors.forEach { $0.alpha = 0 }
    }
    
    // MARK: - UI 设置
    private func setupUI() {
        backgroundColor = .clear
        
        // 配置中心按钮
        centerButton.layer.cornerRadius = menuConfig.centerButtonSize / 2
        centerButton.backgroundColor = menuConfig.centerButtonColor
        if let icon = menuConfig.centerButtonIcon {
            centerButton.setImage(icon, for: .normal)
        }
        
        // 添加中心按钮
        addSubview(centerButton)
        centerButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(menuConfig.centerButtonSize)
        }
        
        // 添加点击事件
        centerButton.addTarget(self, action: #selector(handleCenterButtonTap), for: .touchUpInside)
        
        // 创建扇形区域
        createSectors()
        
        // 添加阴影
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = menuConfig.shadowRadius
        layer.shadowOpacity = menuConfig.shadowOpacity
    }
    
    @objc private func handleCenterButtonTap() {
        // 添加触感反馈
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        // 切换菜单状态
        isMenuExpanded.toggle()
        
        // 执行动画
        UIView.animate(withDuration: menuConfig.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            // 旋转中心按钮
            self.centerButton.transform = self.isMenuExpanded ? CGAffineTransform(rotationAngle: .pi / 4) : .identity
            
            // 更新扇形区域
            self.sectors.enumerated().forEach { index, sector in
                let delay = Double(index) * 0.02
                UIView.animate(withDuration: self.menuConfig.animationDuration, delay: delay, options: [], animations: {
                    sector.alpha = self.isMenuExpanded ? 1 : 0
                    sector.transform = self.isMenuExpanded ? .identity : CGAffineTransform(scaleX: 0.5, y: 0.5)
                })
            }
        })
    }
    
    private var outerRadius: CGFloat {
        return bounds.width / 2
    }
    
    private func createSectors() {
        
        guard !configs.isEmpty else { return }
        
        let angleStep = 2 * CGFloat.pi / CGFloat(configs.count)
        
        for (i, config) in configs.enumerated() {
            let startAngle = angleStep * CGFloat(i)
            let endAngle = startAngle + angleStep
            
            let sectorView = SectorView(
                startAngle: startAngle,
                endAngle: endAngle,
                innerRadius: menuConfig.innerRadius,
                outerRadius: outerRadius,
                config: config
            )
            
            addSubview(sectorView)
            sectors.append(sectorView)
            
            // 为每个扇形区域创建独立的点击手势识别器
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSectorTap(_:)))
            tapGesture.delegate = self
            sectorView.tag = i // 设置tag用于识别不同的扇形区域
            sectorView.addGestureRecognizer(tapGesture)
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 如果点击位置在中心按钮内，则不触发扇形区域的点击手势
        let location = touch.location(in: self)
        if centerButton.frame.contains(location) {
            // 确保中心按钮的点击事件能够触发
            centerButton.sendActions(for: .touchUpInside)
            return false
        }
        return true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        sectors.forEach { $0.center = center }
    }
    
    // MARK: - 手势处理
    @objc private func handleSectorTap(_ gesture: UITapGestureRecognizer) {
        guard let sectorView = gesture.view as? SectorView else { return }
        
        // 添加触感反馈
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        // 调用点击事件回调
        onSectorTap?(sectorView.tag)
        
        // 添加动画效果
        UIView.animate(withDuration: 0.15, animations: {
            sectorView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                sectorView.transform = .identity
            }
        }
    }
}

// MARK: - 图标和标签容器视图
class IconLabelContainer: UIView {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    init(icon: UIImage?, text: String?, spacing: CGFloat = 4) {
        super.init(frame: .zero)
        iconImageView.image = icon
        textLabel.text = text
        setupUI(spacing: spacing, hasIcon: icon != nil, hasText: text != nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(spacing: CGFloat, hasIcon: Bool, hasText: Bool) {
        if hasIcon {
            addSubview(iconImageView)
            iconImageView.snp.makeConstraints { make in
                if hasText {
                    make.top.centerX.equalToSuperview()
                } else {
                    make.center.equalToSuperview()
                }
                make.width.height.equalTo(24)
            }
        }
        
        if hasText {
            addSubview(textLabel)
            textLabel.snp.makeConstraints { make in
                if hasIcon {
                    make.top.equalTo(iconImageView.snp.bottom).offset(spacing)
                } else {
                    make.center.equalToSuperview()
                }
                make.centerX.equalToSuperview()
                make.width.lessThanOrEqualTo(60)
                if hasIcon {
                    make.bottom.equalToSuperview()
                }
            }
        }
    }
}

// MARK: - 扇形视图
class SectorView: UIView {
    private let startAngle: CGFloat
    private let endAngle: CGFloat
    private let innerRadius: CGFloat
    private let outerRadius: CGFloat
    private let config: SectorConfig
    private let contentContainer: IconLabelContainer
    
    init(startAngle: CGFloat, endAngle: CGFloat, innerRadius: CGFloat, outerRadius: CGFloat,
         config: SectorConfig) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.config = config
        
        contentContainer = IconLabelContainer(icon: config.icon, text: config.title, spacing: config.spacing)
        
        // 计算实际需要的视图大小
        let size = CGSize(width: outerRadius * 2, height: outerRadius * 2)
        super.init(frame: CGRect(origin: .zero, size: size))
        
        backgroundColor = .clear
        isUserInteractionEnabled = true
        // 创建内容容器
        addSubview(contentContainer)
        
        drawSector()
        updateContentLayout()
    }
    
    // 更新内容布局
    private func updateContentLayout() {
        // 计算扇形区域的中心角度和角度范围
        let midAngle = (startAngle + endAngle) / 2
        let angleRange = abs(endAngle - startAngle)
        let normalizedAngle = angleRange / (2 * .pi)
        
        // 计算安全区域的半径（考虑内外半径的中点，并添加安全边距）
        let safeRadius = (innerRadius + outerRadius) * 0.5
        
        // 根据扇形大小调整容器尺寸
        let baseWidth: CGFloat = 55
        let baseHeight: CGFloat = 45
//        let scaleFactor = min(1.0, 0.85 + 0.3 * normalizedAngle)
        let scaleFactor = 0.85 + 0.3 * normalizedAngle
        let containerSize = CGSize(
            width: baseWidth * scaleFactor,
            height: baseHeight * scaleFactor
        )
        
        // 计算容器的位置，确保在扇形区域内
        let containerCenter = CGPoint(
            x: bounds.midX + safeRadius * cos(midAngle),
            y: bounds.midY + safeRadius * sin(midAngle)
        )
        
        // 更新容器的位置和大小
        contentContainer.frame = CGRect(
            x: containerCenter.x - containerSize.width / 2,
            y: containerCenter.y - containerSize.height / 2,
            width: containerSize.width,
            height: containerSize.height
        )
        
        // 根据扇形大小动态调整文本大小
        if let label = contentContainer.subviews.last as? UILabel {
//            let fontSize = min(12, 9 + 3 * normalizedAngle)
            let fontSize = 9 + 3 * normalizedAngle
            label.font = .systemFont(ofSize: fontSize, weight: .medium)
        }
        
        // 调整图标大小
        if let imageView = contentContainer.subviews.first as? UIImageView {
            let iconSize = 24 * scaleFactor
            imageView.snp.updateConstraints { make in
                make.width.height.equalTo(iconSize)
            }
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // 计算点击点相对于扇形中心的角度
        let dx = point.x - bounds.midX
        let dy = point.y - bounds.midY
        let distance = sqrt(dx * dx + dy * dy)
        
        // 检查是否在内外半径范围内
        guard distance >= innerRadius && distance <= outerRadius else {
            return false
        }
        
        // 计算角度（弧度）
        var angle = atan2(dy, dx)
        if angle < 0 {
            angle += 2 * .pi
        }
        
        // 检查是否在扇形的角度范围内
        if startAngle <= endAngle {
            return angle >= startAngle && angle <= endAngle
        } else {
            return angle >= startAngle || angle <= endAngle
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawSector() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX + innerRadius * cos(startAngle),
                              y: bounds.midY + innerRadius * sin(startAngle)))
        
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                    radius: outerRadius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true)
        
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                    radius: innerRadius,
                    startAngle: endAngle,
                    endAngle: startAngle,
                    clockwise: false)
        
        path.close()
        
        // 创建渐变层
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            config.color.cgColor,
            config.color.withAlphaComponent(0.9).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        // 创建遮罩层
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        gradientLayer.mask = maskLayer
        
        // 添加阴影
        layer.shadowColor = config.shadowColor.cgColor
        layer.shadowOffset = config.shadowOffset
        layer.shadowRadius = config.shadowRadius
        layer.shadowOpacity = config.shadowOpacity
        
        // 将渐变层插入到最底层，确保图标和文本显示在上层
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
