#!/bin/bash

# GitHub仓库设置脚本

set -e

echo "🚀 OpenClaw OCR技能 - GitHub仓库设置"
echo "======================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查git
if ! command -v git &> /dev/null; then
    echo -e "${RED}错误: git未安装${NC}"
    echo "请安装git: sudo apt-get install git"
    exit 1
fi

# 检查GitHub CLI
if ! command -v gh &> /dev/null; then
    echo -e "${YELLOW}警告: GitHub CLI未安装${NC}"
    echo "可选安装:"
    echo "1. 手动创建GitHub仓库"
    echo "2. 安装GitHub CLI:"
    echo "   sudo apt-get install gh"
    echo "   gh auth login"
fi

echo -e "${BLUE}步骤1: 初始化git仓库${NC}"
git init
git add .
git commit -m "初始提交: OpenClaw OCR技能 v1.0.0"

echo -e "\n${BLUE}步骤2: 创建GitHub仓库${NC}"
echo "请选择创建方式:"
echo "1. 使用GitHub CLI创建（需要登录）"
echo "2. 手动在GitHub网站创建"
echo "3. 跳过，仅本地使用"
read -p "选择 (1/2/3): " choice

case $choice in
    1)
        if command -v gh &> /dev/null; then
            echo -e "${GREEN}使用GitHub CLI创建仓库...${NC}"
            read -p "仓库名称 (默认: openclaw-ocr-skill): " repo_name
            repo_name=${repo_name:-openclaw-ocr-skill}
            
            read -p "仓库描述 (默认: OCR skill for OpenClaw): " repo_desc
            repo_desc=${repo_desc:-OCR skill for OpenClaw}
            
            read -p "是否设为公开仓库? (y/N): " is_public
            if [[ $is_public =~ ^[Yy]$ ]]; then
                visibility="--public"
            else
                visibility="--private"
            fi
            
            gh repo create "$repo_name" --description "$repo_desc" $visibility --source=. --remote=origin --push
        else
            echo -e "${RED}GitHub CLI未安装${NC}"
            echo "请先安装: sudo apt-get install gh && gh auth login"
        fi
        ;;
    2)
        echo -e "${YELLOW}手动创建步骤:${NC}"
        echo "1. 访问 https://github.com/new"
        echo "2. 填写仓库信息:"
        echo "   - Repository name: openclaw-ocr-skill"
        echo "   - Description: OCR skill for OpenClaw"
        echo "   - 选择公开或私有"
        echo "   - 不要初始化README、.gitignore或license"
        echo "3. 创建仓库"
        echo "4. 按照提示添加远程仓库:"
        echo "   git remote add origin https://github.com/你的用户名/openclaw-ocr-skill.git"
        echo "   git push -u origin main"
        ;;
    3)
        echo -e "${YELLOW}跳过GitHub创建，仅本地使用${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}无效选择${NC}"
        exit 1
        ;;
esac

echo -e "\n${BLUE}步骤3: 推送代码${NC}"
if git remote | grep -q origin; then
    echo -e "${GREEN}推送代码到GitHub...${NC}"
    
    # 获取当前分支名
    current_branch=$(git branch --show-current)
    
    git push -u origin "$current_branch"
    
    echo -e "\n${GREEN}✅ 完成!${NC}"
    echo "仓库地址: https://github.com/$(git remote get-url origin | sed 's|.*github.com/||' | sed 's|\.git$||')"
else
    echo -e "${YELLOW}未设置远程仓库${NC}"
    echo "请手动添加远程仓库:"
    echo "  git remote add origin https://github.com/你的用户名/仓库名.git"
    echo "  git push -u origin main"
fi

echo -e "\n${BLUE}步骤4: 发布到ClawdHub（可选）${NC}"
echo "如果你想将技能发布到ClawdHub技能市场:"
echo "1. 确保项目在GitHub上公开"
echo "2. 访问 https://clawdhub.com"
echo "3. 登录并提交你的技能"
echo "4. 等待审核通过"

echo -e "\n${GREEN}🎉 项目设置完成!${NC}"
echo "下一步:"
echo "1. 安装Tesseract OCR: sudo apt-get install tesseract-ocr tesseract-ocr-chi-sim tesseract-ocr-eng"
echo "2. 测试OCR功能: ./scripts/ocr.sh --help"
echo "3. 安装到OpenClaw: sudo cp -r ocr-skill /usr/lib/node_modules/openclaw-cn/skills/"
echo "4. 分享你的技能!"