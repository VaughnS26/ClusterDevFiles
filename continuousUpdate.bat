:loop

git add .
git commit -m "Funne Good Commit Message"
git pull origin main
git push origin main
timeout /t 60
goto loop