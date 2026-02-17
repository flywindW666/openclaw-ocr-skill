#!/usr/bin/env python3
"""
OCR工具 - 从图片中提取文字
支持中文和英文
"""

import sys
import os
import subprocess
import tempfile
from PIL import Image

def check_tesseract():
    """检查tesseract是否安装"""
    try:
        result = subprocess.run(['which', 'tesseract'], 
                              capture_output=True, text=True)
        return result.returncode == 0
    except:
        return False

def install_tesseract():
    """尝试安装tesseract"""
    print("正在尝试安装Tesseract OCR...")
    
    # 检查系统类型
    try:
        with open('/etc/os-release', 'r') as f:
            os_release = f.read()
        
        if 'ubuntu' in os_release.lower() or 'debian' in os_release.lower():
            print("检测到Ubuntu/Debian系统")
            print("请运行以下命令安装：")
            print("sudo apt-get update")
            print("sudo apt-get install -y tesseract-ocr tesseract-ocr-chi-sim tesseract-ocr-eng")
            return False
        elif 'darwin' in sys.platform:
            print("检测到macOS系统")
            print("请运行以下命令安装：")
            print("brew install tesseract tesseract-lang")
            return False
        else:
            print("未知系统，请手动安装Tesseract OCR")
            print("访问: https://github.com/tesseract-ocr/tesseract")
            return False
    except:
        print("无法确定系统类型")
        print("请手动安装Tesseract OCR")
        return False

def ocr_image(image_path, lang='chi_sim+eng'):
    """使用tesseract提取图片文字"""
    if not os.path.exists(image_path):
        return f"错误: 文件不存在 {image_path}"
    
    # 检查文件是否为图片
    try:
        img = Image.open(image_path)
        img.verify()  # 验证图片完整性
    except Exception as e:
        return f"错误: 无效的图片文件 - {str(e)}"
    
    # 创建临时输出文件
    with tempfile.NamedTemporaryFile(mode='w+', suffix='.txt', delete=False) as tmp:
        output_base = tmp.name[:-4]
    
    try:
        # 运行tesseract
        print(f"正在识别图片: {image_path}")
        print(f"使用语言: {lang}")
        
        cmd = ['tesseract', image_path, output_base, '-l', lang]
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode != 0:
            error_msg = result.stderr
            if 'Unable to load language' in error_msg:
                return f"错误: 语言包未安装\n请安装语言包: tesseract-ocr-{lang.split('+')[0]}"
            return f"OCR错误: {error_msg}"
        
        # 读取结果
        with open(f"{output_base}.txt", 'r', encoding='utf-8') as f:
            text = f.read()
        
        return text.strip()
    except FileNotFoundError:
        return "错误: tesseract未安装"
    except Exception as e:
        return f"处理错误: {str(e)}"
    finally:
        # 清理临时文件
        if os.path.exists(f"{output_base}.txt"):
            os.unlink(f"{output_base}.txt")

def list_supported_languages():
    """列出支持的语言"""
    try:
        result = subprocess.run(['tesseract', '--list-langs'], 
                              capture_output=True, text=True)
        if result.returncode == 0:
            langs = result.stdout.strip().split('\n')[1:]  # 跳过第一行"List of available languages"
            return langs
        return []
    except:
        return []

def main():
    """主函数"""
    if len(sys.argv) < 2:
        print("OCR图片文字提取工具")
        print("用法: python ocr_tool.py <图片路径> [语言]")
        print("示例: python ocr_tool.py image.jpg chi_sim")
        print("示例: python ocr_tool.py image.jpg eng")
        print("示例: python ocr_tool.py image.jpg chi_sim+eng")
        print("\n可用命令:")
        print("  --list-langs  列出支持的语言")
        print("  --install     显示安装说明")
        return
    
    # 处理特殊命令
    if sys.argv[1] == '--list-langs':
        langs = list_supported_languages()
        if langs:
            print("支持的语言:")
            for lang in langs:
                print(f"  - {lang}")
        else:
            print("无法获取语言列表，请检查tesseract是否安装")
        return
    
    if sys.argv[1] == '--install':
        install_tesseract()
        return
    
    # 正常OCR处理
    image_path = sys.argv[1]
    lang = sys.argv[2] if len(sys.argv) > 2 else 'chi_sim+eng'
    
    # 检查tesseract是否安装
    if not check_tesseract():
        print("错误: Tesseract OCR未安装")
        install_tesseract()
        return
    
    # 执行OCR
    text = ocr_image(image_path, lang)
    
    if text.startswith("错误:"):
        print(text)
        sys.exit(1)
    
    print("\n" + "="*50)
    print("提取的文字内容:")
    print("="*50)
    print(text)
    print("="*50)

if __name__ == "__main__":
    main()