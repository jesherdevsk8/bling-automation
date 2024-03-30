#!/usr/bin/env bash

SCRIPT_PATH="$HOME/github/freelas/bling"
continue_execution=true

while [ "$continue_execution" = true ]; do
  continue_execution=false

  echo "Executando vupload.py"
  python3 "$SCRIPT_PATH"/webdriver/vupload.py > >(tee -a stdout.log) 2> >(tee -a stderr.log >&2)

  if [ $? -eq 1 ]; then
    echo "Erro ao executar vupload.py."
    echo "Executando upload.py....."
    python3 "$SCRIPT_PATH"/webdriver/upload.py > >(tee -a stdout.log) 2> >(tee -a stderr.log >&2)
    continue_execution=true
  fi

  echo "Executando upload.py novamente"
  python3 "$SCRIPT_PATH"/webdriver/upload.py > >(tee -a stdout.log) 2> >(tee -a stderr.log >&2)

  if [ $? -eq 1 ]; then
    echo "Erro ao executar upload.py novamente."
    echo "Executando vupload.py"
    python3 "$SCRIPT_PATH"/webdriver/vupload.py > >(tee -a stdout.log) 2> >(tee -a stderr.log >&2)
    continue_execution=true
  fi
done

echo "ACABOU... CHECK O LOG"
