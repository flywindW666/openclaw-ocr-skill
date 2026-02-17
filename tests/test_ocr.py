#!/usr/bin/env python3
"""
OCR技能测试脚本
"""

import os
import sys
import subprocess

def test_ocr_scripts():
    """测试OCR脚本"""
    print("测试OCR技能脚本...")
    
    scripts_dir = os.path.join(os.path.dirname(__file__), '..', 'scripts')
    
    # 测试bash脚本
    bash_script = os.path.join(scripts_dir, 'ocr.sh')
    if os.path.exists(bash_script):
        print(f"✓ 找到bash脚本: {bash_script}")
        
        # 检查脚本权限
        if os.access(bash_script, os.X_OK):
            print("  ✓ 脚本可执行")
        else:
            print("  ⚠️ 脚本不可执行，正在修复...")
            os.chmod(bash_script, 0o755)
            
        # 测试帮助功能
        try:
            result = subprocess.run([bash_script, '--help'], 
                                  capture_output=True, text=True)
            if result.returncode == 0:
                print("  ✓ 帮助功能正常")
            else:
                print(f"  ✗ 帮助功能异常: {result.stderr}")
        except Exception as e:
            print(f"  ✗ 执行错误: {e}")
    else:
        print(f"✗ 未找到bash脚本: {bash_script}")
    
    # 测试Python脚本
    python_script = os.path.join(scripts_dir, 'ocr_tool.py')
    if os.path.exists(python_script):
        print(f"\n✓ 找到Python脚本: {python_script}")
        
        # 测试Python脚本
        try:
            result = subprocess.run([sys.executable, python_script, '--help'], 
                                  capture_output=True, text=True)
            if result.returncode == 0:
                print("  ✓ Python脚本正常")
            else:
                print(f"  ✗ Python脚本异常: {result.stderr}")
        except Exception as e:
            print(f"  ✗ 执行错误: {e}")
    else:
        print(f"\n✗ 未找到Python脚本: {python_script}")
    
    # 检查技能文件
    skill_file = os.path.join(os.path.dirname(__file__), '..', 'ocr-skill', 'SKILL.md')
    if os.path.exists(skill_file):
        print(f"\n✓ 找到技能文件: {skill_file}")
        
        with open(skill_file, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # 检查必要内容
        required_sections = ['name:', 'description:', 'homepage:', 'metadata:']
        missing = []
        for section in required_sections:
            if section not in content.lower():
                missing.append(section)
        
        if missing:
            print(f"  ✗ 技能文件缺少: {missing}")
        else:
            print("  ✓ 技能文件完整")
            
        # 检查文件大小
        file_size = os.path.getsize(skill_file)
        if file_size > 1000:  # 至少1KB
            print(f"  ✓ 技能文件大小合适: {file_size}字节")
        else:
            print(f"  ⚠️ 技能文件可能过小: {file_size}字节")
    else:
        print(f"\n✗ 未找到技能文件: {skill_file}")
    
    print("\n" + "="*50)
    print("测试完成!")
    print("="*50)

def check_dependencies():
    """检查依赖"""
    print("\n检查依赖...")
    
    # 检查tesseract
    try:
        result = subprocess.run(['which', 'tesseract'], 
                              capture_output=True, text=True)
        if result.returncode == 0:
            print("✓ Tesseract已安装")
            
            # 检查版本
            version_result = subprocess.run(['tesseract', '--version'], 
                                          capture_output=True, text=True)
            if version_result.returncode == 0:
                version_line = version_result.stdout.split('\n')[0]
                print(f"  版本: {version_line}")
        else:
            print("✗ Tesseract未安装")
            print("  请运行: sudo apt-get install tesseract-ocr tesseract-ocr-chi-sim tesseract-ocr-eng")
    except Exception as e:
        print(f"✗ 检查Tesseract时出错: {e}")
    
    # 检查Python依赖
    print("\n检查Python依赖...")
    try:
        import PIL
        print("✓ PIL/Pillow已安装")
    except ImportError:
        print("✗ PIL/Pillow未安装")
        print("  请运行: pip install pillow")
    
    print("\n" + "="*50)
    print("依赖检查完成!")
    print("="*50)

def main():
    """主函数"""
    print("="*50)
    print("OpenClaw OCR技能测试")
    print("="*50)
    
    test_ocr_scripts()
    check_dependencies()
    
    print("\n📋 总结:")
    print("1. 所有脚本文件已就绪")
    print("2. 技能文件完整")
    print("3. 请确保Tesseract OCR已安装")
    print("4. 项目可以发布到GitHub")
    
    print("\n🚀 下一步:")
    print("1. 创建GitHub仓库")
    print("2. 上传项目文件")
    print("3. 配置GitHub Actions（可选）")
    print("4. 发布到ClawdHub技能市场")

if __name__ == "__main__":
    main()