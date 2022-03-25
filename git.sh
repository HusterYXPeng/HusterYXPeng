echo "发布hexo到github page"
hexo clean && hexo g && hexo d

echo "提交源码到master"
git add -a
git commit -m "update blog ..."
git push origin HEAD:master

echo "success all..."