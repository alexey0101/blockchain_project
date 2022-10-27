const Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("INFURA ENDPOINT"));
const address = "0x866739cCE3483c3113e46BDfAB80dC9F3d291833";
const ABI = [
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "a",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "b",
				"type": "uint256"
			}
		],
		"name": "sum",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "a",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "b",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "result",
				"type": "uint256"
			}
		],
		"name": "Sum",
		"type": "event"
	}
];
const signer = web3.eth.accounts.privateKeyToAccount('ACCOUNT PRIVATE KEY');
web3.eth.accounts.wallet.add(signer);
web3.eth.getBalance // проверяем
const myContract = new web3.eth.Contract(ABI, address)
const tx = myContract.methods.sum(5, 12);
const txReceipt = await tx.send({
  from: signer.address,
  gas: await tx.estimateGas(),
});

myContract.getPastEvents('Sum', {fromBlock: 0, toBlock: 'latest'}, (error, events) => console.log(events))
