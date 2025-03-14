let sessionLabel = UILabel() //创建UILabel的类型对象，命名为sL;UILabel是用来显示一行或多行文本的UI组件，就像一哦个标签，用来展示文字，比如标题
sessionLabel.translatesAutoresizingMaskIntoConstraints = false // 默认情况下IOS会自动调整UIL的大小位置，我们不希望自动所以设置为false,我们要自己手动设置
sessionLabel.text = "No counter selected" //文本内容设置为" "

view.addSubview(sessionLabel) //把 UILabel 添加到界面/屏幕上
//确保 sessionLabel 先被添加到 view，再添加约束
//如果 sessionLabel 还没有 addSubview(sessionLabel)，它还不属于 view 的层级。但是你却尝试先运行下面的约束，就会run崩溃

NSLayoutConstraint.activate([
    //让 Label 的宽度等于 view.layoutMarginsGuide 的宽度,multiplier: 1 表示 宽度比例为 1 倍（就是和 view.layoutMarginsGuide 的宽度一样大）
    sessionLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1),
    // Label 的 X 轴中心点对齐 view 的中心点,Label 就会在屏幕的水平正中央！
    sessionLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
    // Label 的 Y 轴中心点对齐 view.layoutMarginsGuide.topAnchor,constant: 50 让 Label 向下偏移 50 像素;Label 就会出现在屏幕的上方，并且距离顶部 50 像素！
    sessionLabel.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50)
])




// 在 Auto Layout 中，我们用**约束（Constraints）**来控制 UI 组件的位置和大小。
// NSLayoutConstraint.activate([...]) 是用来激活一组 Auto Layout 约束的语法。

/**
iOS 坐标系统中：
X 轴是从左到右变大（👉）
Y 轴是从上到下变大（👇）
所以 constant 的值对 X 轴（水平位置） 影响如下：
constant: 正数 → 向右移动
constant: 负数 → 向左移动
所以 constant 的值对 y 轴（垂直位置） 影响如下：
constant: 正数 → 向下移动
constant: 负数 → 向上移动
*/
