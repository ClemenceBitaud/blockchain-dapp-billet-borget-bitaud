pragma solidity >=0.4.99 <0.6.0;

import "./StandardToken.sol";

contract Bank {
    address private owner;
    address private token;

    constructor(address tokenAddress) public {
        token = tokenAddress;
        owner = msg.sender;
    }

    function buy() public payable {
        require(msg.value == 1 ether, "ERROR : INVALID VALUE");
        address payable wallet = address(uint160(owner));
        wallet.transfer(msg.value);

        require(
            StandardToken(token).allowance(owner, address(this)) >= 100,
            "ERROR : OWNER NOT ALLOWED"
        );
        require(
            StandardToken(token).transferFrom(owner, msg.sender, 100),
            "ERROR : TRANSFER FAIL"
        );
    }

    function showBalance() public view returns (uint256) {
        return StandardToken(token).allowance(owner, address(this));
    }
}
