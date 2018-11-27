#!/bin/bash
COMMIT_MESSAGE=""

for string in "$@"
  do
    COMMIT_MESSAGE+=" $string"
done

if [[ -z $COMMIT_MESSAGE ]]
  then
    echo "Нет сообщения для коммита"
  else
    echo "$(git status)"

    echo "Ну что деплоить будем?"
    select yn in "Да" "Нет"; do
        case $yn in
            Да)
              git add -A;
              git commit -m "$COMMIT_MESSAGE";
              git push;
              cap production deploy;
              break;;
            Нет)
              exit;;
        esac
    done
fi
