#!/bin/bash

# 快速设置 Codex skills 加载脚本
# 支持指定要加载的 skills，而不是全部自动加载

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_SKILLS_DIR="${SCRIPT_DIR}/.codex/skills"
CONFIG_FILE="${SCRIPT_DIR}/.codex-skills-config"

# 显示使用说明
show_usage() {
    cat << EOF
用法: $0 [选项] [skill路径...]

选项:
  -h, --help              显示此帮助信息
  -l, --list              列出所有可用的 skills
  -c, --config FILE       从配置文件加载 skill 列表
  -i, --interactive       交互式选择要加载的 skills
  -r, --remove SKILL      移除指定的 skill
  -a, --all               加载所有找到的 skills（默认行为已改为需要指定）

示例:
  # 加载指定的 skills
  $0 myskills/research-paper-writer anthropics-skills-guide/skills/doc-coauthoring

  # 从配置文件加载
  $0 --config .codex-skills-config

  # 交互式选择
  $0 --interactive

  # 列出所有可用 skills
  $0 --list

  # 移除某个 skill
  $0 --remove research-paper-writer
EOF
}

# 查找所有可用的 skills
find_all_skills() {
    local skills=()
    
    # myskills
    if [ -d "${SCRIPT_DIR}/myskills" ]; then
        while IFS= read -r skill_dir; do
            if [ -f "${skill_dir}/SKILL.md" ]; then
                skills+=("${skill_dir}")
            fi
        done < <(find "${SCRIPT_DIR}/myskills" -mindepth 1 -maxdepth 1 -type d)
    fi
    
    # anthropics-skills-guide
    if [ -d "${SCRIPT_DIR}/anthropics-skills-guide/skills" ]; then
        while IFS= read -r skill_dir; do
            if [ -f "${skill_dir}/SKILL.md" ]; then
                skills+=("${skill_dir}")
            fi
        done < <(find "${SCRIPT_DIR}/anthropics-skills-guide/skills" -mindepth 1 -maxdepth 1 -type d)
    fi
    
    # refskills (递归)
    if [ -d "${SCRIPT_DIR}/refskills" ]; then
        while IFS= read -r skill_dir; do
            if [ -f "${skill_dir}/SKILL.md" ]; then
                skills+=("${skill_dir}")
            fi
        done < <(find "${SCRIPT_DIR}/refskills" -type f -name "SKILL.md" -exec dirname {} \; | sort -u)
    fi
    
    # openai-skills-guide
    if [ -d "${SCRIPT_DIR}/openai-skills-guide/openai-skills/skills" ]; then
        while IFS= read -r skill_dir; do
            if [ -f "${skill_dir}/SKILL.md" ]; then
                skills+=("${skill_dir}")
            fi
        done < <(find "${SCRIPT_DIR}/openai-skills-guide/openai-skills/skills" -mindepth 1 -maxdepth 1 -type d)
    fi
    
    printf '%s\n' "${skills[@]}"
}

# 列出所有可用的 skills
list_skills() {
    echo "📋 可用的 skills:"
    echo ""
    
    local skills=()
    while IFS= read -r skill; do
        [ -n "$skill" ] && skills+=("$skill")
    done < <(find_all_skills)
    
    if [ ${#skills[@]} -eq 0 ]; then
        echo "  未找到任何 skills"
        return
    fi
    
    for skill in "${skills[@]}"; do
        local rel_path="${skill#$SCRIPT_DIR/}"
        local skill_name=$(basename "$skill")
        echo "  - $skill_name"
        echo "    路径: $rel_path"
        
        # 读取 skill 描述（如果有）
        if [ -f "${skill}/SKILL.md" ]; then
            local desc=$(grep -E "^description:" "${skill}/SKILL.md" | head -1 | sed 's/^description:[[:space:]]*//' | cut -c1-80)
            if [ -n "$desc" ]; then
                echo "    描述: $desc..."
            fi
        fi
        echo ""
    done
    
    echo "💡 使用方式:"
    echo "  $0 <skill路径1> <skill路径2> ..."
    echo ""
    echo "示例:"
    echo "  $0 myskills/research-paper-writer"
    echo "  $0 myskills/research-paper-writer anthropics-skills-guide/skills/doc-coauthoring"
}

# 链接 skill
link_skill() {
    local skill_path="$1"
    
    # 检查路径是否存在
    if [ ! -d "$skill_path" ]; then
        # 尝试相对路径
        if [ -d "${SCRIPT_DIR}/${skill_path}" ]; then
            skill_path="${SCRIPT_DIR}/${skill_path}"
        else
            echo "❌ 错误: 找不到 skill 路径: $1"
            return 1
        fi
    fi
    
    # 检查是否有 SKILL.md
    if [ ! -f "${skill_path}/SKILL.md" ]; then
        echo "❌ 错误: ${skill_path} 不是有效的 skill（缺少 SKILL.md）"
        return 1
    fi
    
    local skill_name=$(basename "$skill_path")
    local target="${CODEX_SKILLS_DIR}/${skill_name}"
    
    # 检查是否已存在
    if [ -e "${target}" ]; then
        echo "⏭️  跳过 ${skill_name} (已存在)"
        return 0
    fi
    
    # 创建符号链接
    local rel_path=$(realpath --relative-to="${CODEX_SKILLS_DIR}" "${skill_path}" 2>/dev/null || echo "${skill_path}")
    ln -s "${rel_path}" "${target}"
    echo "✅ 已链接: ${skill_name}"
    return 0
}

# 移除 skill
remove_skill() {
    local skill_name="$1"
    local target="${CODEX_SKILLS_DIR}/${skill_name}"
    
    if [ ! -e "${target}" ]; then
        echo "❌ 错误: skill '${skill_name}' 不存在"
        return 1
    fi
    
    rm "${target}"
    echo "✅ 已移除: ${skill_name}"
    return 0
}

# 交互式选择
interactive_select() {
    local skills=()
    while IFS= read -r skill; do
        [ -n "$skill" ] && skills+=("$skill")
    done < <(find_all_skills)
    
    if [ ${#skills[@]} -eq 0 ]; then
        echo "❌ 未找到任何 skills"
        return 1
    fi
    
    echo "📋 请选择要加载的 skills (输入数字，多个用空格分隔，如: 1 3 5):"
    echo ""
    
    local i=1
    local selected_indices=()
    for skill in "${skills[@]}"; do
        local skill_name=$(basename "$skill")
        local rel_path="${skill#$SCRIPT_DIR/}"
        echo "  [$i] $skill_name ($rel_path)"
        ((i++))
    done
    
    echo ""
    read -p "请输入选择: " selection
    
    # 解析选择
    for num in $selection; do
        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ${#skills[@]} ]; then
            selected_indices+=($((num - 1)))
        fi
    done
    
    if [ ${#selected_indices[@]} -eq 0 ]; then
        echo "❌ 未选择任何 skill"
        return 1
    fi
    
    # 创建目录
    mkdir -p "${CODEX_SKILLS_DIR}"
    
    # 链接选中的 skills
    local linked_count=0
    for idx in "${selected_indices[@]}"; do
        if link_skill "${skills[$idx]}"; then
            ((linked_count++))
        fi
    done
    
    echo ""
    echo "✨ 完成！已链接 ${linked_count} 个 skills"
}

# 从配置文件加载
load_from_config() {
    local config_file="$1"
    
    if [ ! -f "$config_file" ]; then
        echo "❌ 错误: 配置文件不存在: $config_file"
        return 1
    fi
    
    # 创建目录
    mkdir -p "${CODEX_SKILLS_DIR}"
    
    local linked_count=0
    while IFS= read -r line || [ -n "$line" ]; do
        # 跳过空行和注释
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        
        # 去除首尾空格
        line=$(echo "$line" | xargs)
        
        if link_skill "$line"; then
            ((linked_count++))
        fi
    done < "$config_file"
    
    echo ""
    echo "✨ 完成！已链接 ${linked_count} 个 skills"
}

# 主逻辑
main() {
    # 创建 .codex/skills 目录
    mkdir -p "${CODEX_SKILLS_DIR}"
    
    # 解析参数
    local mode="link"
    local skills_to_link=()
    local config_file=""
    local skill_to_remove=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -l|--list)
                list_skills
                exit 0
                ;;
            -i|--interactive)
                interactive_select
                exit 0
                ;;
            -c|--config)
                config_file="$2"
                shift
                ;;
            -r|--remove)
                skill_to_remove="$2"
                shift
                ;;
            -a|--all)
                # 加载所有 skills
                while IFS= read -r skill; do
                    [ -n "$skill" ] && skills_to_link+=("$skill")
                done < <(find_all_skills)
                ;;
            *)
                skills_to_link+=("$1")
                ;;
        esac
        shift
    done
    
    # 处理移除操作
    if [ -n "$skill_to_remove" ]; then
        remove_skill "$skill_to_remove"
        exit 0
    fi
    
    # 从配置文件加载
    if [ -n "$config_file" ]; then
        load_from_config "$config_file"
        exit 0
    fi
    
    # 如果没有指定任何 skill，显示帮助
    if [ ${#skills_to_link[@]} -eq 0 ]; then
        echo "❌ 错误: 请指定要加载的 skills"
        echo ""
        show_usage
        echo ""
        echo "💡 提示: 使用 '$0 --list' 查看所有可用的 skills"
        exit 1
    fi
    
    # 链接指定的 skills
    local linked_count=0
    for skill_path in "${skills_to_link[@]}"; do
        if link_skill "$skill_path"; then
            ((linked_count++))
        fi
    done
    
    echo ""
    echo "✨ 完成！已链接 ${linked_count} 个 skills"
    echo ""
    echo "📝 下一步："
    echo "   1. 重启 Codex 以加载新的 skills"
    echo "   2. 在 Codex 中使用 \`/skills\` 命令查看可用的 skills"
    echo "   3. 使用 \`\$skill-name\` 来显式调用某个 skill"
}

main "$@"
