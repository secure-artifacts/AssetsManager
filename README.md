# AssetsManager — 数字资产管理器

![AssetsManager Icon](resources/icon_256x256.png)

AssetsManager 是一款专为视频剪辑师和数字艺术家设计的专业数字资产管理工具。基于 Python 和 PySide6 (Qt Quick/QML) 构建，旨在提供流畅、高效的素材管理体验。

## ✨ 主要特性

- 📂 **智能扫描**: 递归扫描文件夹，快速索引数千个媒体文件。
- 🖼️ **自动缩略图**: 自动为图片和视频生成高质量预览缩略图（支持 ffmpeg/PyAV 加速）。
- 🏷️ **标签系统**: 强大的标签管理功能，支持自定义分类和过滤。
- 🔍 **秒级检索**: 使用 SQLite 数据库进行全文索引，支持按名称、路径或标签即时搜索。
- 🖥️ **现代化 UI**: 响应式 Qt Quick 层级界面，支持流畅的动画效果和深色模式。
- 🖱️ **无缝集成**: 支持拖拽（Drag & Drop）至 DaVinci Resolve 等外部剪辑软件。
- 🔒 **离线优先**: 所有数据和缩略图均本地存储，确保隐私和速度。

## 🛠️ 技术栈

- **核心**: Python 3.11+
- **界面**: PySide6 (Qt for Python), QML
- **数据库**: SQLAlchemy (SQLite)
- **图像/视频**: Pillow, PyAV (av)
- **打包**: Nuitka

## 🚀 快速开始

### 1. 克隆仓库
```bash
git clone https://github.com/your-username/AssetsManager.git
cd AssetsManager
```

### 2. 创建虚拟环境并安装依赖
```bash
python -m venv venv
source venv/bin/activate  # Windows 使用: venv\Scripts\activate
pip install -r requirements.txt
```

### 3. 运行程序
```bash
python AssetsManager.py
```

## 📦 打包与分发

项目使用 **Nuitka** 进行静态编译打包，以获得最佳性能和独立的运行环境。

### 打包 macOS 应用
```bash
python -m nuitka AssetsManager.py
```
*(注意：编译配置已集成在 `AssetsManager.py` 的文档字符串中)*

### 打包 Windows 应用
项目包含 `installer.nsi` 脚本，可使用 NSIS 制作安装包。

## 🤝 贡献说明

欢迎提交 Issue 或 Pull Request 来改进本项目。

## 📜 许可证

本项目采用 [MIT License](LICENSE) 许可协议。
