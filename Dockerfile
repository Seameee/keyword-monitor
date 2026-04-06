# 关键词监控机器人 Dockerfile
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# 复制项目文件
COPY pyproject.toml ./
COPY src/ ./src/

# 安装 Python 依赖
RUN pip install --no-cache-dir -e .

# 创建数据目录
RUN mkdir -p /app/data

# 设置环境变量
ENV PYTHONUNBUFFERED=1
ENV CONFIG_DIR=/app/data

# 暴露端口
EXPOSE 8080

# 创建启动脚本
RUN echo '#!/bin/bash\n\
CONFIG_FILE="/app/data/config.json"\n\
DB_FILE="/app/data/data.db"\n\
\n\
# 如果配置文件不存在，创建默认空配置\n\
if [ ! -f "$CONFIG_FILE" ]; then\n\
    echo "Creating default config..."\n\
    echo '"'"'"'{"'"'"'forums"'"'"': [], '"'"'admin_chat_id"'"'"': null}'"'"' > "$CONFIG_FILE"\n\
fi\n\
\n\
# 初始化数据库（如果不存在）\n\
if [ ! -f "$DB_FILE" ]; then\n\
    echo "Initializing database..."\n\
    linux-do-monitor db-init\n\
fi\n\
\n\
# 启动服务\n\
echo "Starting service..."\n\
linux-do-monitor run --web-port 8080 --config-dir /app/data\n\
' > /app/entrypoint.sh && chmod +x /app/entrypoint.sh

# 启动命令
CMD ["/app/entrypoint.sh"]
