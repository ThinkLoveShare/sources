# Desctiption

This github contains the sources for thinkloveshare.com
This project is using hugo and github pages.

# How to contribute
```bash
git clone https://github.com/ThinkLoveShare/sources
cd sources
# Make changes
git status
git add .
git commit -a -m "I did THAT_THING on THIS_FILE"
git push
```

# Format to use
Hugo syntax : https://sourceforge.net/p/hugo-generator/wiki/markdown_syntax
Extended md : https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
```html
<!-- Custom images size -->
<img class="img_{full,big,med,small}" alt="image_name" src="/path/to/img.ext" >
```

# How to test locally
```bash
# Install hugo : https://github.com/gohugoio/hugo
# In sources :
rm -rf resources; hugo serve
# Reach http://localhost:1313/
```

# How to deploy
```bash
# In sources :
git clone git@github.com:ThinkLoveShare/ThinkLoveShare.github.io.git
/bin/rm -rf resources ThinkLoveShare.github.io/*
hugo -d ThinkLoveShare.github.io/
cd ThinkLoveShare.github.io/
git add .
git commit -a -m "I did THAT_THING on THIS_FILE"
git push
# Reach https://thinkloveshare.com/
# Usually, deploy time takes less that one minute.
```
