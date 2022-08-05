require('dotenv').config();

const { AdminClient } = require('defender-admin-client');
const { RelayClient} = require('defender-relay-client');
const { AutotaskClient } = require('defender-autotask-client');
const { SentinelClient } = require('defender-sentinel-client');

const adminClient = new AdminClient({ apiKey: process.env.TEAM_API_KEY, apiSecret: process.env.TEAM_SECRET_KEY });
const relayClient = new RelayClient({ apiKey: process.env.TEAM_API_KEY, apiSecret: process.env.TEAM_SECRET_KEY });
const autotaskClient = new AutotaskClient({ apiKey: process.env.TEAM_API_KEY, apiSecret: process.env.TEAM_SECRET_KEY });
const sentinelClient = new SentinelClient({ apiKey: process.env.TEAM_API_KEY, apiSecret: process.env.TEAM_SECRET_KEY });

async function main() {

  const address = '0xEB0032C90E550Fb160f5334F15CE21173A8c14E0';
  const network = 'rinkeby';

  const lotteryContract = await adminClient.addContract({
    network: network,
    address: address,
    name: 'Lottery Contract',
  });
  
  const lotteryRelay = await relayClient.create({
    name: 'Lottery Relay',
    network: network,
    minBalance: BigInt(1e17).toString(),
    policies: {
      whitelistReceivers: [ address ],
      EIP1559Pricing: true,
    },
  });
  
  const lotteryRelayApiKey = await relayClient.createKey(lotteryRelay.relayerId);
  
  const getRandomNumberAutotask = await autotaskClient.create({
    name: 'Get Random Number Autotask',
    encodedZippedCode: await autotaskClient.getEncodedZippedCodeFromFolder('./defender/autotasks/getRandomNumber'),
    relayerId: lotteryRelay.relayerId,
    trigger: {
      type: 'schedule',
      frequencyMinutes: 1440,
    },
    paused: false,
  });
  
  const pickWinnerAutotask = await autotaskClient.create({
    name: 'Pick Winner Autotask',
    encodedZippedCode: await autotaskClient.getEncodedZippedCodeFromFolder('./defender/autotasks/pickWinner'),
    relayerId: lotteryRelay.relayerId,
    trigger: {
      type: 'webhook',
    },
    paused: false,
  });
  
  const lotterySentinel = await sentinelClient.create({
    type: 'BLOCK',
    network: network,
    name: 'Lottery Sentinel',
    addresses: [ address ],
    paused: false,
    eventConditions: [ { eventSignature: 'RandomNumber()' } ],
    autotaskTrigger: pickWinnerAutotask.autotaskId,
    notificationChannels: [],
  });

}

main();
