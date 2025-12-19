#!/bin/sh

PORT=1313

echo "正在查找并杀死占用端口 $PORT 的进程..."

# 查找进程PID
PID=$(netstat -lnp 2>/dev/null | grep ":$PORT" | awk '{print $7}' | cut -d'/' -f1)

# 如果没找到，尝试lsof
[ -z "$PID" ] && PID=$(lsof -ti:$PORT 2>/dev/null)

# 杀死进程
if [ -n "$PID" ]; then
    echo "杀死进程: $PID"
    kill -9 $PID 2>/dev/null
    
    # 验证进程是否被杀死
    sleep 1
    if ps -p $PID > /dev/null 2>&1; then
        echo "警告: 进程可能仍然在运行"
    else
        echo "进程已成功终止"
    fi
else
    echo "没有找到占用端口 $PORT 的进程"
fi
