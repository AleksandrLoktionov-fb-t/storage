New-Item -Path "$Env:USERPROFILE\.gitignore_global" -ItemType File -Force
Add-Content -Path "$Env:USERPROFILE\.gitignore_global" -Value "`n.env`n.env.local"
git config --global core.excludesfile "$Env:USERPROFILE\.gitignore_global"
