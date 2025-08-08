# 📚 Mobile Full-Stack 学习笔记

## 📑 目录
- [1. 基础概念科普](#1-基础概念科普)
  - [1.1 iOS 开发](#11-ios-开发)
  - [1.2 Android 开发](#12-android-开发)
  - [1.3 Mobile 开发](#13-mobile-开发)
  - [1.4 Mobile Full-Stack](#14-mobile-full-stack)
- [2. MetExplorer 与深耕 iOS 对照](#2-metexplorer-与深耕-ios-对照)
  - [2.1 深耕 iOS 学习清单](#21-深耕-ios-学习清单)
  - [2.2 建议补齐](#22-建议补齐)
- [3. 是否参加 CodePath iOS 102](#3-是否参加-codepath-ios-102)
- [4. 从现在到 Mobile Full-Stack 的路线图](#4-从现在到-mobile-full-stack-的路线图)
- [5. 时间建议](#5-时间建议)
- [6. 检查清单（到位标准）](#6-检查清单到位标准)
- [7. 两个里程碑项目](#7-两个里程碑项目)

---

## 1. 基础概念科普

### 1.1 iOS 开发
- **平台**：苹果生态（iPhone、iPad、Apple Watch、Apple TV）  
- **语言**：Swift（现代主流）、Objective-C（老项目）  
- **工具**：Xcode（苹果官方 IDE）  
- **UI 框架**：
  - UIKit（经典，老项目主流）
  - SwiftUI（新趋势，声明式 UI）
- **数据存储**：Core Data（老）、SwiftData（2023 新）  
- **发布渠道**：App Store  

---

### 1.2 Android 开发
- **平台**：安卓生态（三星、华为、小米、Pixel 等）  
- **语言**：Kotlin（现代主流）、Java（老项目）  
- **工具**：Android Studio  
- **UI 框架**：
  - XML + View System（老项目）
  - Jetpack Compose（新趋势，声明式 UI）
- **数据存储**：Room（SQLite 封装）、DataStore  
- **发布渠道**：Google Play、厂商应用市场  

---

### 1.3 Mobile 开发
- **涵盖范围**：
  1. 原生开发（iOS: Swift / Objective-C，Android: Kotlin / Java）
  2. 跨平台开发（Flutter、React Native 等）
  3. 混合开发（WebView + 原生壳）

---

### 1.4 Mobile Full-Stack
- **定义**：一个人能完成移动应用的前端 + 后端开发  
- **前端（App 部分）**：UI、交互、API 调用、本地存储（iOS / Android / 跨平台）  
- **后端（Server 部分）**：API 服务、数据库、云部署、安全策略  
- **优势**：可独立开发和部署完整的移动端产品  

---

## 2. MetExplorer 与深耕 iOS 对照

### 2.1 深耕 iOS 学习清单
| 学习重点 | MetExplorer 覆盖情况 | 备注 |
|----------|----------------------|------|
| SwiftUI + Combine / async-await | ✅（async/await） | Combine 可选，Swift Concurrency 已够用 |
| SwiftData + Core Data | ✅（SwiftData） | SwiftData 是新趋势 |
| 网络层封装（URLSession、Alamofire） | ✅ 基础完成 | 可优化为通用网络层 |
| App 架构（MVVM、Clean Architecture） | ✅ 基础 MVVM | 可增强依赖注入、可测试性 |
| Apple API（MapKit、Camera、Push Notifications） | ❌ 未覆盖 | 可加 MapKit 等功能 |
| 上架流程（App Store Connect） | ❌ 未覆盖 | 可做 TestFlight + 上架流程 |

---

### 2.2 建议补齐
1. **系统 API**：MapKit、Camera、推送通知  
2. **上架流程**：TestFlight 测试、App Store 审核  
3. **进阶架构**：依赖注入、协议化、单元/UI 测试  
4. **本地化 + 无障碍**：en/zh 双语、VoiceOver  
5. **工程化**：CI/CD、Fastlane 自动化  

---

## 3. 是否参加 CodePath iOS 102
- **优点**：
  - 多一个成品项目 + CodePath 经历  
  - 学习 UIKit（面试/老项目常用）  
  - 有同学、导师人脉  
- **缺点**：
  - 技术栈较旧（UIKit + Parse）  
  - 对 SwiftUI 熟练的人提升有限  
- **建议**：
  - 想补 UIKit & 人脉 → 可参加  
  - 想专注 SwiftUI 进阶 → 投入到 MetExplorer 更高效  

---

## 4. 从现在到 Mobile Full-Stack 的路线图

**Phase 0｜通用基础（1–2 周）**
- Git / GitHub 协作
- HTTP/JSON 基础
- 阅读官方文档能力

**Phase 1｜iOS 进阶（2–4 周）**
- SwiftUI（导航、状态、动画）
- SwiftData（关系、迁移）
- URLSession 封装、错误处理、缓存
- MVVM + DI、单元测试
- 本地化、无障碍
- 上架链路（TestFlight）

**Phase 2｜Android（2–4 周）**
- Kotlin 基础、Jetpack Compose
- Room（关系、迁移）、DataStore
- Retrofit 网络封装
- 生命周期/权限
- UI/单元测试
- Play Console 提交流程

**Phase 3｜后端（2–4 周）**
- Node.js/Spring Boot/FastAPI
- PostgreSQL/MongoDB、迁移工具
- REST/GraphQL 设计
- 认证授权、安全策略
- Docker 部署、云服务
- CI/CD 流程

**Phase 4｜全链路整合（2–3 周）**
- iOS + Android 共用后端
- 双端认证、推送、文件上传
- 离线缓存、冲突解决
- Deep Link、Universal Link

**Phase 5｜移动安全（贯穿）**
- OWASP MASVS 标准
- TLS、证书固定
- 数据加密存储
- Jailbreak/Root 检测
- API 密钥管理、混淆
- 静态/动态分析、API 安全测试

**Phase 6｜跨平台视角（1–2 周，可选）**
- Flutter 或 React Native
- 原生与跨平台对比

**Phase 7｜作品集与求职（1–2 周）**
- README 完善（动图、架构图）
- 技术总结文章（iOS、Android、安全）
- 面试准备（API、架构、调优、发布流程）
- Demo 视频录制

---

## 5. 时间建议
- **轻量轨**（每周 5–7 小时）：3–4 个月完成主线  
- **进取轨**（每周 10–15 小时）：8–10 周完成主线  

---

## 6. 检查清单（到位标准）
**iOS**
- [ ] SwiftUI 复杂界面
- [ ] SwiftData 模型关系
- [ ] MVVM + DI
- [ ] 单元/UI 测试
- [ ] 本地化 + 无障碍
- [ ] TestFlight 流程

**Android**
- [ ] Compose 导航/列表
- [ ] Room 迁移
- [ ] Retrofit 协程
- [ ] 测试覆盖

**后端**
- [ ] 认证授权
- [ ] 分页筛选
- [ ] 日志与监控
- [ ] 云部署

**安全**
- [ ] 密钥安全存储
- [ ] 证书固定
- [ ] MASVS 自检表

---

## 7. 两个里程碑项目
1. **双端 + 后端**：收藏/标签/搜索/离线缓存/推送  
2. **安全加固版**：落实 MASVS 关键项 + 技术文档  


