// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract QTKN {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowance;
    uint256 public totalSupply = 50000 * 10 ** 18;
    string public constant name = "QTKN";
    
    string public constant symbol = "QTKN";
    uint256 public constant decimals = 18;  

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Bought(uint256 amount);


    constructor(address account) {  
        balances[account] = 0;
    }  

    function balanceOf(address tokenOwner) public view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(totalSupply >= value, "balance too low");
        balances[to] += value;
        totalSupply -= value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(balanceOf(from) >= value, "balance too low");    
        require(allowance[from][msg.sender] >= value, "allowance too low");
        balances[to] += value;
        balances[from] -= value;       
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function buy(uint256 _amount, address sender) payable public returns(uint256){
        uint256 amountTobuy = _amount;
        uint256 QTKNBalance = totalSupply;
        require(amountTobuy > 0, "You need to send some ether");
        require(amountTobuy <= QTKNBalance, "Not enough tokens in the reserve");
        transfer(sender, amountTobuy);
        emit Bought(amountTobuy);
        return amountTobuy;
    }
  }
