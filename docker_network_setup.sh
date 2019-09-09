
echo Input name for network
read name
docker network create -d bridge $name

echo Starting first node

docker run -d \
    --name=roach1 \
    --hostname=roach1 \
    --net=$name \
    -p 26257:26257 -p 8080:8080  \
    -v "${PWD}/cockroach-data/roach1:/cockroach/cockroach-data"  \
    cockroachdb/cockroach:v19.1.4 start --insecure

echo Starting second node

docker run -d \
    --name=roach2 \
    --hostname=roach2 \
    --net=$name \
    -v "${PWD}/cockroach-data/roach2:/cockroach/cockroach-data" \
    cockroachdb/cockroach:v19.1.4 start --insecure --join=roach1

echo Starting third node

docker run -d \
    --name=roach3 \
    --hostname=roach3 \
    --net=$name \
    -v "${PWD}/cockroach-data/roach3:/cockroach/cockroach-data" \
    cockroachdb/cockroach:v19.1.4 start --insecure --join=roach1

echo All nodes created

docker network inspect $name
