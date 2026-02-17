---
name: OCR文字识别
description: 使用Tesseract OCR从图片中提取文字。支持多种语言，包括中文和英文。当用户需要从图片、截图或文档图片中提取文字时使用。
homepage: https://github.com/tesseract-ocr/tesseract
metadata: {"clawdbot":{"emoji":"🔍","os":["linux","darwin"],"requires":{"bins":["tesseract"]},"install":[{"id":"apt","kind":"apt","packages":["tesseract-ocr","tesseract-ocr-chi-sim","tesseract-ocr-eng"],"bins":["tesseract"],"label":"Install Tesseract OCR via apt"},{"id":"brew","kind":"brew","formula":"tesseract","bins":["tesseract"],"label":"Install Tesseract OCR via Homebrew"}]}}
---

# OCR文字识别技能

使用Tesseract OCR从图片中提取文字。支持多种语言，包括中文、英文等。

## 安装

### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install -y tesseract-ocr tesseract-ocr-chi-sim tesseract-ocr-eng
```

### macOS (Homebrew)
```bash
brew install tesseract
brew install tesseract-lang  # 安装语言包
```

### 安装语言包
- 中文简体: `tesseract-ocr-chi-sim`
- 中文繁体: `tesseract-ocr-chi-tra`
- 英文: `tesseract-ocr-eng`
- 日文: `tesseract-ocr-jpn`
- 韩文: `tesseract-ocr-kor`

## 基本使用

### 从图片提取文字
```bash
# 基本用法
tesseract 图片路径 输出文件名

# 示例
tesseract image.jpg output
# 结果保存到 output.txt

# 指定语言（中文简体）
tesseract image.jpg output -l chi_sim

# 指定语言（英文）
tesseract image.jpg output -l eng

# 指定语言（中文+英文）
tesseract image.jpg output -l chi_sim+eng
```

### 在Python中使用
```python
import pytesseract
from PIL import Image

# 安装pytesseract: pip install pytesseract pillow

# 打开图片
image = Image.open('image.jpg')

# 提取文字
text = pytesseract.image_to_string(image, lang='chi_sim+eng')
print(text)
```

## 常用命令

### 查看支持的语言
```bash
tesseract --list-langs
```

### 从图片直接输出到终端
```bash
tesseract image.jpg stdout -l chi_sim
```

### 批量处理图片
```bash
for img in *.jpg; do
    tesseract "$img" "${img%.jpg}_text" -l chi_sim
done
```

## 高级选项

### 提高识别准确率
```bash
# 使用PSM模式（页面分割模式）
tesseract image.jpg output -l chi_sim --psm 3

# PSM模式说明：
# 0 = 方向和脚本检测 (OSD)
# 1 = 自动页面分割与OSD
# 2 = 自动页面分割，但不进行OSD或OCR
# 3 = 全自动页面分割，但不进行OSD（默认）
# 4 = 假设单列可变大小的文本
# 5 = 假设垂直对齐的单一文本块
# 6 = 假设单一统一的文本块
# 7 = 将图像视为单个文本行
# 8 = 将图像视为单个单词
# 9 = 将图像视为圆形中的单个单词
# 10 = 将图像视为单个字符
```

### 输出格式
```bash
# 输出为PDF
tesseract image.jpg output pdf -l chi_sim

# 输出为hOCR（HTML格式）
tesseract image.jpg output hocr -l chi_sim
```

## 在OpenClaw中使用

### 简单OCR函数
```bash
# 创建OCR脚本
cat > /usr/local/bin/ocr.sh << 'EOF'
#!/bin/bash
if [ $# -eq 0 ]; then
    echo "用法: ocr.sh <图片路径> [语言]"
    echo "示例: ocr.sh image.jpg chi_sim"
    exit 1
fi

IMAGE=$1
LANG=${2:-chi_sim+eng}
OUTPUT="${IMAGE%.*}_text"

tesseract "$IMAGE" "$OUTPUT" -l "$LANG"
cat "${OUTPUT}.txt"
EOF

chmod +x /usr/local/bin/ocr.sh
```

### Python OCR工具
```python
#!/usr/bin/env python3
import sys
import subprocess
import os

def ocr_image(image_path, lang='chi_sim+eng'):
    """使用tesseract提取图片文字"""
    if not os.path.exists(image_path):
        return f"错误: 文件不存在 {image_path}"
    
    # 创建临时输出文件
    import tempfile
    with tempfile.NamedTemporaryFile(mode='w+', suffix='.txt', delete=False) as tmp:
        output_base = tmp.name[:-4]
    
    try:
        # 运行tesseract
        cmd = ['tesseract', image_path, output_base, '-l', lang]
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode != 0:
            return f"OCR错误: {result.stderr}"
        
        # 读取结果
        with open(f"{output_base}.txt", 'r', encoding='utf-8') as f:
            text = f.read()
        
        # 清理临时文件
        os.unlink(f"{output_base}.txt")
        
        return text.strip()
    except Exception as e:
        return f"处理错误: {str(e)}"
    finally:
        # 确保清理临时文件
        if os.path.exists(f"{output_base}.txt"):
            os.unlink(f"{output_base}.txt")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法: python ocr_tool.py <图片路径> [语言]")
        sys.exit(1)
    
    image_path = sys.argv[1]
    lang = sys.argv[2] if len(sys.argv) > 2 else 'chi_sim+eng'
    
    text = ocr_image(image_path, lang)
    print(text)
```

## 注意事项

1. **图片质量**：清晰的图片识别效果更好
2. **语言选择**：根据文字内容选择合适的语言
3. **字体大小**：文字不宜过小
4. **背景对比**：文字与背景应有足够对比度
5. **安装依赖**：确保已安装必要的语言包

## 故障排除

### 常见问题
1. **"语言包未找到"**：安装对应的语言包
2. **识别准确率低**：尝试调整PSM模式或预处理图片
3. **中文识别错误**：确保安装了中文语言包 `tesseract-ocr-chi-sim`

### 图片预处理建议
```bash
# 使用ImageMagick预处理图片（如果需要）
convert input.jpg -resize 200% -threshold 50% processed.jpg
tesseract processed.jpg output -l chi_sim
```

现在你已经有了OCR技能！可以方便地从图片中提取文字了。