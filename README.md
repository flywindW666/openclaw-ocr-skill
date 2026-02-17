# OpenClaw OCR Skill

![GitHub Actions](https://github.com/flywindW666/openclaw-ocr-skill/actions/workflows/test.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![OpenClaw](https://img.shields.io/badge/OpenClaw-Skill-green.svg)

一个为OpenClaw设计的OCR（光学字符识别）技能，使用Tesseract OCR从图片中提取文字。

## 功能特性

- ✅ 支持中文、英文等多种语言
- ✅ 简单易用的命令行工具
- ✅ 完整的OpenClaw技能集成
- ✅ 错误处理和安装指导
- ✅ 支持批量处理

## 安装

### 1. 安装Tesseract OCR

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install -y tesseract-ocr tesseract-ocr-chi-sim tesseract-ocr-eng
```

**macOS:**
```bash
brew install tesseract
brew install tesseract-lang
```

### 2. 安装OpenClaw OCR技能

```bash
# 克隆仓库
git clone https://github.com/flywindW666/openclaw-ocr-skill.git
cd openclaw-ocr-skill

# 复制到OpenClaw技能目录
sudo cp -r ocr-skill /usr/lib/node_modules/openclaw-cn/skills/
```

## 使用方法

### 作为OpenClaw技能使用

当OpenClaw技能安装后，你可以：
- 通过OpenClaw界面使用OCR功能
- 在聊天中发送图片并提取文字
- 使用命令行工具批量处理

### 命令行工具

```bash
# 基本使用
./ocr.sh image.jpg

# 指定语言
./ocr.sh image.jpg chi_sim      # 中文简体
./ocr.sh image.jpg eng          # 英文
./ocr.sh image.jpg chi_sim+eng  # 中英文混合

# Python版本
python3 ocr_tool.py image.jpg
```

### 在OpenClaw中使用

```bash
# 通过OpenClaw执行OCR
openclaw exec -- ocr.sh image.jpg
```

## 项目结构

```
ocr-project/
├── README.md                 # 项目说明
├── LICENSE                   # 开源许可证
├── ocr-skill/               # OpenClaw技能目录
│   └── SKILL.md            # 技能定义文件
├── scripts/                 # 工具脚本
│   ├── ocr.sh              # Bash OCR脚本
│   └── ocr_tool.py         # Python OCR工具
├── examples/               # 示例文件
│   └── sample.jpg         # 示例图片
└── tests/                  # 测试文件
    └── test_ocr.py        # 测试脚本
```

## 开发

### 添加新语言支持

1. 安装对应的Tesseract语言包：
   ```bash
   # 中文繁体
   sudo apt-get install tesseract-ocr-chi-tra
   
   # 日文
   sudo apt-get install tesseract-ocr-jpn
   
   # 韩文
   sudo apt-get install tesseract-ocr-kor
   ```

2. 更新技能文档

### 测试

```bash
# 运行测试
cd tests
python3 test_ocr.py
```

## 贡献

欢迎提交Issue和Pull Request！

1. Fork本仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 致谢

- [Tesseract OCR](https://github.com/tesseract-ocr/tesseract) - 优秀的OCR引擎
- [OpenClaw](https://openclaw.ai) - 强大的AI助手平台
- 所有贡献者和用户

## 支持

如有问题，请：
1. 查看 [Issues](https://github.com/yourusername/openclaw-ocr-skill/issues)
2. 提交新的Issue
3. 或通过电子邮件联系

---

**让OpenClaw更强大！** 🚀