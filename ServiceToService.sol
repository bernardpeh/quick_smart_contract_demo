pragma solidity ^0.4.24;

// Demo on how we can use smart contract in our day to day life to exchange service for service
contract ServiceToService {

    struct User {
        bool staked;
        bool delivered;
        bool acknowledged;
    }

    mapping(address => User) public users;

    address buyer;
    address seller;

    // both parties require to stake 1 eth
    uint staked_value = 1 ether;

    // step 1. buyer creates contract with seller's address and stake value
    constructor(address _seller) payable public {
        require(msg.value == staked_value);
        buyer = msg.sender;
        seller = _seller;
        users[buyer].staked = true;
    }
    // step 2. seller stake value
    function sellerStaked() payable public {
        require(msg.sender == seller);
        require(msg.value == staked_value);
        users[msg.sender].staked = true;
    }

    // step 3. service delivered
    function serviceDelivered() public {
        require(users[msg.sender].staked == true && users[msg.sender].delivered == false);
        users[msg.sender].delivered = true;
    }

    // step 4. service accepted
    function serviceAcknowledged() public {
        if (msg.sender == buyer) {
            users[seller].acknowledged = true;
        }
        if (msg.sender == seller) {
            users[buyer].acknowledged = true;
        }
    }

    // buyer or seller can withdraw their stake funds if their service is delivered and accepted.
    // In real, we would subject to more conditions to ensure fair deal.
    function refund() public {
        if (users[msg.sender].staked == true && users[msg.sender].delivered == true
        && users[msg.sender].acknowledged == true)
            msg.sender.transfer(staked_value);
    }
}