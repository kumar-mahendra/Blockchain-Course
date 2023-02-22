//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

interface IERC20Token {
    // totalSupply - it returns the initial quantity of rolled out tokens
    function totalSupply() external view returns(uint256);

    // balanceOf - it returns the number of tokens hold by any particular address
    function balanceOf(address _owner) external returns(uint256);

    // transfer - it is to transfer the tokens from one account to another
    function transfer(address _to, uint256 _value) external returns(bool success);

    // approve - it approves the spender to use it's own tokens
    function approve(address _spender, uint256 _value) external returns(bool success);

    // transferFrom - once approved, it is used to transfer all or partial allowed/approved tokens to spender
    function transferFrom(address _from, address _to, uint256 _value) external returns(bool success);

    // allowance - it is to know the remaining approved tokens 
    function allowance(address _owner, address _spender) external view returns(uint256 remaining);

    // Events
    // Transfer - it is used to log the transfer function activity like from account, to account and how many
    //            tokens were transferred
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    // Approval - it is used to log the approve function activity like from account, to account and how many
    //            tokens were approved 
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


contract ERC20Token  is IERC20Token {
    mapping(address => uint256) public _balances;
    mapping(address => mapping(address => uint256)) public _allowances;

    // name, symbol, decimal 
    string public name = "Amusement Park";
    string public symbol = "APT";
    uint256 public decimals = 0;

    // uint256 - initial supply
    uint256 public _totalSupply; 

    // address - creator's address 
    address public _creator;

    constructor() {
        _totalSupply = 50000;
        _balances[msg.sender] = _totalSupply;
        _creator = msg.sender;
    }

    function totalSupply() external view returns(uint256){
        return _totalSupply;
    }

    function balanceOf(address _owner) external view returns(uint256){
        return _balances[_owner];
    }

    function transfer(address _to, uint256 _value) external returns(bool success){
        require(_value>0 && _balances[msg.sender] >= _value, "Insufficient balance");
        _balances[msg.sender] -= _value;
        _balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns(bool success){
        require(_value>0 && _balances[msg.sender] >= _value, "Insufficient balance");
        _allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns(bool success){
        require(_value>0 && _balances[_from] >= _value && _allowances[_from][_to] >= _value, "Insufficient balance");
        _balances[_from] -= _value;
        _balances[_to] += _value;
        _allowances[_from][_to] -= _value;
        return true;
    }

    function allowance(address _owner, address _spender) external view returns(uint256 remaining){
        return _allowances[_owner][_spender];
    }

}

