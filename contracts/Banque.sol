pragma solidity >=0.5.0 <0.5.17;

import "./Token.sol";


/**
 * @title Banque
 * @dev token purchase bank (1eth = 100 token)
 */
contract Banque {
    address private owner;
    address private token;

    /**
     * @dev Set contract deployer as owner & set token contract address
     */
    constructor(address tokenaddress) public {
        token = tokenaddress;
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
    }

    /**
     * @dev buy 100 token for 1 ethereum
     */
    function buy() public payable {
        require(msg.value == 1 ether, "invalid value -> 1eth = 100 token"); // check the amount paid for the purchase = 1eth
        address payable portefeuille = address(uint160(owner)); // converted the owner's address to a payable address
        portefeuille.transfer(msg.value); // transfer the amount received to the owner account

        require(
            Token(token).allowance(owner, address(this)) >= 100, // check the amount authorized by owner> = nb token user buy
            "owner not allowed"
        );
        require(
            Token(token).transferFrom(owner, msg.sender, 100), // token transfer
            "transfert fail"
        );
    }

    /**
     * @dev number of token available for buy
     */
    function afficherBalance() public view returns (uint256) {
        return Token(token).allowance(owner, address(this)); // amount that the owner has authorized to be used by the contract
    }
}
