pragma solidity >=0.4.99 <0.6.0;

contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    function transferFrom(address from, address to, uint256 value) public returns (bool) {}
    function approve(address spender, uint256 value) public returns (bool);
    function allowance(address owner, address spender) public view returns (uint256);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value
    );
}

contract StandardToken is ERC20Basic {
    string public name = "StandardToken";
    string public symbol = "STANTOK";
    uint8 public decimals = 15;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) allowed;
    uint256 public _totalSupply;

    constructor(uint256 total) public {
        _totalSupply = total;
        balances[msg.sender] = _totalSupply;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address who) public view returns (uint256) {
        return balances[who];
    }

    function transfer(address to, uint256 value) public returns (bool){
        if(balances[msg.sender] >= value && value > 0){
            balances[msg.sender] -= value;
            balances[to] += value;
            emit Transfer(msg.sender, to, value);
            return true;
        }else{
            return false;
        }
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(allowed[from][msg.sender] >0 && allowed[from][msg.sender] >= value,
            "ERROR : NOT ALLOWED");
        if(balances[from] >= value && value > 0){
            balances[to] += value;
            balances[from] -= value;
            allowed[from][msg.sender] -= value;
            emit Transfer(from, to, value);
            return true;
        }else{
            return false;
        }
    }

    function approve(address spender, uint256 value) public returns (bool){
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256){
        return allowed[owner][spender];
    }
}

