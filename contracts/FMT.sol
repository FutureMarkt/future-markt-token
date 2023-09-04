// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FutureMarktToken is ERC20, Ownable {
    event CostChange(uint256 _cost);
    event AmountChange(uint256 _amount);
    event WithDraw(uint256 _amount, address indexed _owner, uint256 _timestamp);

    uint256 public cost = 1 ether;
    uint256 public mintAmount = 10000 * 10 ** decimals();
    uint256 public maxSupply = 20000000 * 10 ** decimals();

    constructor() ERC20("FutureMarktToken", "FMT") {
        _mint(msg.sender, 10000000 * 10 ** decimals());
    }

    function mint() public payable {
        require(msg.value >= cost, "Not enough ether");
        require(
            totalSupply() + mintAmount <= maxSupply,
            "Maximum supply trashold exceeded"
        );
        _mint(msg.sender, mintAmount);
    }

    function burn(uint256 _amount) public {
        _burn(msg.sender, _amount);
    }

    function changeCost(uint256 _cost) public onlyOwner {
        cost = _cost;
        emit CostChange(_cost);
    }

    function changeAmount(uint256 _amount) public onlyOwner {
        mintAmount = _amount;
        emit AmountChange(_amount);
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
        emit WithDraw(address(this).balance, msg.sender, block.timestamp);
    }
}
