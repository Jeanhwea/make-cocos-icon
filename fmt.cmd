:<<"::CMDLITERAL"
@ECHO OFF
GOTO :CMDSCRIPT
::CMDLITERAL

# fmt.cmd format source codes
# THIS SCRIPTS WORKS FOR ALL SYSTEMS Linux/Windows/macOS

set -eux
uv run autoflake -i -r src
uv run isort src main.py
uv run black src
uv run ruff format src main.py

exit 0

:CMDSCRIPT

uv run autoflake -i -r src
uv run isort src
uv run black src
uv run ruff format src main.py
