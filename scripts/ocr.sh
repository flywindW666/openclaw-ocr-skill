#!/bin/bash

# OCR脚本 - 从图片中提取文字

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查参数
if [ $# -eq 0 ]; then
    echo -e "${BLUE}OCR图片文字提取工具${NC}"
    echo "用法: $0 <图片路径> [语言]"
    echo "示例: $0 image.jpg chi_sim"
    echo "示例: $0 image.jpg eng"
    echo "示例: $0 image.jpg chi_sim+eng"
    echo ""
    echo "可用选项:"
    echo "  --list-langs  列出支持的语言"
    echo "  --install     显示安装说明"
    echo "  --help        显示帮助信息"
    exit 1
fi

# 检查tesseract是否安装
check_tesseract() {
    if ! command -v tesseract &> /dev/null; then
        echo -e "${RED}错误: Tesseract OCR未安装${NC}"
        return 1
    fi
    return 0
}

# 显示安装说明
show_install() {
    echo -e "${YELLOW}安装Tesseract OCR:${NC}"
    echo ""
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            ubuntu|debian)
                echo -e "${GREEN}Ubuntu/Debian系统:${NC}"
                echo "sudo apt-get update"
                echo "sudo apt-get install -y tesseract-ocr tesseract-ocr-chi-sim tesseract-ocr-eng"
                ;;
            fedora)
                echo -e "${GREEN}Fedora系统:${NC}"
                echo "sudo dnf install tesseract tesseract-langpack-chi_sim tesseract-langpack-eng"
                ;;
            arch)
                echo -e "${GREEN}Arch Linux系统:${NC}"
                echo "sudo pacman -S tesseract tesseract-data-chi_sim tesseract-data-eng"
                ;;
            *)
                echo "请根据你的系统安装Tesseract OCR:"
                echo "访问: https://github.com/tesseract-ocr/tesseract"
                ;;
        esac
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${GREEN}macOS系统:${NC}"
        echo "brew install tesseract"
        echo "brew install tesseract-lang"
    else
        echo "请手动安装Tesseract OCR:"
        echo "访问: https://github.com/tesseract-ocr/tesseract"
    fi
}

# 列出支持的语言
list_langs() {
    if check_tesseract; then
        echo -e "${BLUE}支持的语言:${NC}"
        tesseract --list-langs | tail -n +2
    else
        show_install
        exit 1
    fi
}

# 处理特殊命令
case "$1" in
    --list-langs)
        list_langs
        exit 0
        ;;
    --install)
        show_install
        exit 0
        ;;
    --help|-h)
        echo -e "${BLUE}OCR图片文字提取工具${NC}"
        echo "用法: $0 <图片路径> [语言]"
        echo ""
        echo "示例:"
        echo "  $0 screenshot.png"
        echo "  $0 document.jpg chi_sim"
        echo "  $0 text.png eng"
        echo "  $0 mixed.jpg chi_sim+eng"
        echo ""
        echo "选项:"
        echo "  --list-langs  列出支持的语言"
        echo "  --install     显示安装说明"
        echo "  --help        显示帮助信息"
        exit 0
        ;;
esac

# 正常OCR处理
IMAGE="$1"
LANG="${2:-chi_sim+eng}"

# 检查文件是否存在
if [ ! -f "$IMAGE" ]; then
    echo -e "${RED}错误: 文件不存在 '$IMAGE'${NC}"
    exit 1
fi

# 检查tesseract
if ! check_tesseract; then
    show_install
    exit 1
fi

# 创建临时文件
TEMP_OUTPUT=$(mktemp)

echo -e "${BLUE}正在识别图片:${NC} $IMAGE"
echo -e "${BLUE}使用语言:${NC} $LANG"
echo ""

# 执行OCR
tesseract "$IMAGE" "$TEMP_OUTPUT" -l "$LANG" 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 识别成功${NC}"
    echo ""
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${GREEN}提取的文字内容:${NC}"
    echo -e "${YELLOW}========================================${NC}"
    cat "${TEMP_OUTPUT}.txt"
    echo -e "${YELLOW}========================================${NC}"
    
    # 询问是否保存到文件
    read -p "是否保存到文件? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        OUTPUT_FILE="${IMAGE%.*}_text.txt"
        cp "${TEMP_OUTPUT}.txt" "$OUTPUT_FILE"
        echo -e "${GREEN}✓ 已保存到: $OUTPUT_FILE${NC}"
    fi
else
    echo -e "${RED}✗ 识别失败${NC}"
    echo "可能的原因:"
    echo "1. 语言包未安装 (运行: $0 --install)"
    echo "2. 图片质量太差"
    echo "3. 文字太小或模糊"
fi

# 清理临时文件
rm -f "${TEMP_OUTPUT}.txt"