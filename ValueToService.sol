pragma solidity ^0.4.24;

// Quick demo of how we can use smart contract in our day to day life to exchange value for service
contract ValueToService {
    
    address public buyer;
    address public seller;
    bytes32 public hashed_password;
    
    // ensures caller is seller only
    modifier sellerOnly {
        require(msg.sender == seller, "seller address not correct");
        _;
    }
    
    // ensures that caller is buyer only
    modifier buyerOnly {
        require(msg.sender == buyer, "buyer address not correct");
        _;
    }
    
    // buyer creates contract with seller's address, hash of secret password and put in some funds
    constructor(address _seller, bytes32 _hashed_password) payable public {
        buyer = msg.sender;
        seller = _seller;
        hashed_password = _hashed_password;
    }
    
    // buyer acknowledges that service has been delivered and gives password to seller. Sell can now withdraw funds
    function releaseFunds(uint _password) sellerOnly public {
        require(hashed_password == keccak256(abi.encodePacked(_password)),"password is wrong");
        seller.transfer(address(this).balance);
    }
    
    // buyer can withdraw the funds anytime as well. In real, we would subject this to certain conditions.
    function refund() buyerOnly public {
        selfdestruct(buyer);
    }
}

