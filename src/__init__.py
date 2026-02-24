# -*- coding: utf-8 -*-
import logging
import os
import sys

# 添加工程根目录到 Python 路径
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# 关闭字节码生成
os.environ["PYTHONDONTWRITEBYTECODE"] = "1"
os.environ["QT_API"] = "pyside6"
DEBUGGING = os.environ.get("DD") not in (None, "", "0", "false", "no", "off")

_APP_LOG_LEVEL = logging.DEBUG if DEBUGGING else logging.INFO

logging.basicConfig(level=_APP_LOG_LEVEL, format="%(message)s")


# 让未捕获的异常自动记录到日志
def handle_uncaught_exception(exc_type, exc_value, exc_traceback):
    if issubclass(exc_type, KeyboardInterrupt):
        sys.__excepthook__(exc_type, exc_value, exc_traceback)
        return
    logger.error("未捕获的异常", exc_info=(exc_type, exc_value, exc_traceback))


sys.excepthook = handle_uncaught_exception
