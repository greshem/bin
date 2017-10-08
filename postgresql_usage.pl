#==========================================================================
docker pull sameersbn/postgresql:9.4

docker run --name=postgresql -d \
-e 'DB_NAME=gitlabhq_production' -e 'DB_USER=gitlab' -e 'DB_PASS=password' \
-v /home/username/opt/postgresql/data:/var/lib/postgresql -p 5432:5432 \
sameersbn/postgresql:9.4

#==========================================================================
#1. 通过 安装 可以安装  pgadmin3了
    https://www.postgresql.org/ftp/pgadmin3/release/v1.22.2/win32/
