// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DemlikCoin {
    string public name = "Demlik Coin";
    string public symbol = "DMLK";
    uint8 public decimals = 8;
    uint256 public totalSupply;
    address public owner;
    address public loyaltyPool;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Mint(address indexed to, uint256 value);

    constructor(uint256 _initialSupply, address _loyaltyPool) {
        owner = msg.sender;
        loyaltyPool = _loyaltyPool;
        totalSupply = _initialSupply;
        balanceOf[msg.sender] = _initialSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Yetersiz bakiye");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Yetersiz bakiye");
        require(allowance[_from][msg.sender] >= _value, "Yetersiz yetki");

        balanceOf[_from] -= _value;
        allowance[_from][msg.sender] -= _value;

        uint256 loyaltyAmount = _value / 100;
        uint256 amountToTransfer = _value - loyaltyAmount;

        balanceOf[_to] += amountToTransfer;
        balanceOf[loyaltyPool] += loyaltyAmount;

        emit Transfer(_from, _to, amountToTransfer);
        emit Transfer(_from, loyaltyPool, loyaltyAmount);

        return true;
    }

    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Yetersiz bakiye");

        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;

        emit Burn(msg.sender, _value);

        return true;
    }

    function mint(uint256 _value) public returns (bool success) {
        require(msg.sender == owner, "Sadece sahibi mint edebilir");

        balanceOf[owner] += _value;
        totalSupply += _value;

        emit Mint(owner, _value);

        return true;
    }
}
