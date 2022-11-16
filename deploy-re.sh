BLUE_ALIVE=$(docker exec $(docker ps --format "table {{.Names}}" | grep nginx) curl -X GET http://testproject-blue:8081/alive-check)


if [[ $BLUE_ALIVE == "ALIVE" ]]
then
  docker-compose -f docker-compose.yml stop testproject-green
  docker-compose -f docker-compose.yml up --build testproject-green -d
  while [ true ];
  do
    GREEN_ALIVE=$(docker exec $(docker ps --format "table {{.Names}}" | grep nginx) curl -X GET http://testproject-green:8082/alive-check)
    if [[ $GREEN_ALIVE == "ALIVE" ]]
    then
      # shellcheck disable=SC2091
      $(docker exec $(docker ps --format "table {{.Names}}" | grep nginx) sed -i "s/blue/green/" /etc/nginx/conf.d/service-url.inc)
      docker-compose -f docker-compose.yml stop testproject-blue
      $(docker exec $(docker ps --format "table {{.Names}}" | grep nginx) service nginx reload)
      break;
    fi
      sleep 10
  done
else
  docker-compose -f docker-compose.yml stop testproject-blue
  docker-compose -f docker-compose.yml up --build testproject-blue -d
  while [ true ];
  do
    BLUE_ALIVE=$(docker exec $(docker ps --format "table {{.Names}}" | grep nginx) curl -X GET http://testproject-blue:8081/alive-check)
    if [[ $BLUE_ALIVE == "ALIVE" ]]
    then
      $(docker exec $(docker ps --format "table {{.Names}}" | grep nginx) sed -i "s/green/blue/" /etc/nginx/conf.d/service-url.inc)
      docker-compose -f docker-compose.yml stop testproject-green
      $(docker exec $(docker ps --format "table {{.Names}}" | grep nginx) service nginx reload)
      break;
    fi
      sleep 10
  done
fi