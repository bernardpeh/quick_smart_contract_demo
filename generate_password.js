var web3 = require('web3-utils')

let passwd = '1111'

// Note that web3.sha3 is different from solidity's keccak256 function. We have to use web3.soliditySha3 instead
console.log(web3.soliditySha3(passwd))
