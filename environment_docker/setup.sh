#!/bin/bash
HOST_NAME="ec2-18-118-86-93.us-east-2.compute.amazonaws.com"

# Start containers
docker start shopping
docker start forum
docker start kiwix33

# Start classifieds (multi-container)
cd classifieds_docker_compose
docker compose up --build -d
cd ..

# Wait for services to start
echo "Waiting for services to start..."
sleep 60

# Populate classifieds DB (only run once — comment out after first run)
# docker exec classifieds_db mysql -u root -ppassword osclass -e 'source docker-entrypoint-initdb.d/osclass_craigslist.sql'

# Configure shopping URL
docker exec shopping /var/www/magento2/bin/magento setup:store-config:set --base-url="http://${HOST_NAME}:7770"
docker exec shopping mysql -u magentouser -pMyPassword magentodb -e "UPDATE core_config_data SET value='http://${HOST_NAME}:7770/' WHERE path = 'web/secure/base_url';"
docker exec shopping /var/www/magento2/bin/magento cache:flush

# Disable re-indexing of products
docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalogrule_product
docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalogrule_rule
docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalogsearch_fulltext
docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalog_category_product
docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule customer_grid
docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule design_config_grid
docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule inventory
docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalog_product_category
docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalog_product_attribute
docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule catalog_product_price
docker exec shopping /var/www/magento2/bin/magento indexer:set-mode schedule cataloginventory_stock

echo "Setup complete. Services available at:"
echo "  Shopping:    http://${HOST_NAME}:7770"
echo "  Forum:       http://${HOST_NAME}:9999"
echo "  Wikipedia:   http://${HOST_NAME}:8888"
echo "  Classifieds: http://${HOST_NAME}:9980"
