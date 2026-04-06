#!/bin/bash
CONFIG_FILE="/app/data/config.json"
DB_FILE="/app/data/data.db"

# 如果配置文件不存在，创建默认空配置
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Creating default config..."
    echo '{"forums": [], "admin_chat_id": null}' > "$CONFIG_FILE"
fi

# 初始化数据库（如果不存在）
if [ ! -f "$DB_FILE" ]; then
    echo "Initializing database..."
    linux-do-monitor db-init
fi

# 启动服务
echo "Starting service..."
linux-do-monitor run --web-port 8080 --config-dir /app/data
