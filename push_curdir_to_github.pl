
use Cwd;
use File::Basename;

our $g_pwd=getcwd();
our $g_basename=basename($g_pwd);
our $g_dirname=dirname($g_pwd);

print <<EOF
git init ./
git add -A 
git commit -m "Mdf_1m: add " 
git remote add origin git@github.com:greshem/$g_basename.git
git push -u origin master 

EOF
;
