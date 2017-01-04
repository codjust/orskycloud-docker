echo "orskycloud service start...."
docker run -d -p 80:80 -p 6379:6379 -v /etc/redis/database:/etc/redis/database orskycloud:1.7
