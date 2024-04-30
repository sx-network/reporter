
# Become a reporter for SX Network

## Running a reporter node

Interested in helping out to report market outcomes on SX Network? Please visit our docs [here](https://docs.sx.technology/developers/become-a-validator) for instructions on how to run your own node and get compensated in SX for your efforts.

## Reporter maintenance

Reporter node operators are required to routinely update their reporter's version of sx-node, maintain a high uptime (99%), and monitor the health of their instances. This section will evolve over time to include links and how-to guides essential to the duties of a node operator.

### Updating to the latest version of sx-reporter-node

From within your `reporter` directory: 
```
git pull && chmod +x update_reporter.sh && ./update_reporter.sh "$(curl http://checkip.amazonaws.com)"
```
