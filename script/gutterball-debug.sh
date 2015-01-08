# error out if called directly
if [ $BASH_SOURCE == $0 ]
then
  echo "This script should not be executed directly, use foreman-debug instead."
  exit 1
fi

# Gutterball
add_files /var/log/gutterball/*
add_files /etc/gutterball/certs/ampq/gutterball.truststore
add_files /etc/candlepin/certs/ampq/candlepin.truststore
add_files /etc/gutterball/gutterball.conf
