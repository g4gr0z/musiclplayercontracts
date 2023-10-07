// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./MusicNFT.sol";

contract MusicPlayer is Ownable {
    ERC20 public fractionalizedToken;  
    MusicNFT public musicNFT;  
    
    mapping(uint256 => mapping(address => uint256)) public fractionalOwnership;
    uint256 public initialFNFTs;

    constructor(address _fractionalizedToken, address _musicNFT, uint256 _initialFNFTs, address initialOwner) Ownable(initialOwner){
        fractionalizedToken = ERC20(_fractionalizedToken);
        musicNFT = MusicNFT(_musicNFT);
        initialFNFTs = _initialFNFTs;
    }

  
    function purchaseFraction(uint256 tokenId, uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(musicNFT.ownerOf(tokenId) == address(this), "Music track not held by contract");
        
        uint256 totalSupply = fractionalizedToken.totalSupply();
       
        
        require(totalSupply + amount > totalSupply, "Overflow error");
        require(totalSupply + amount >= amount, "Underflow error");
        require(fractionalizedToken.balanceOf(msg.sender) >= amount, "Insufficient balance");
        
        fractionalizedToken.transferFrom(msg.sender, address(this), amount);
        fractionalOwnership[tokenId][msg.sender] += amount;

        emit FractionPurchased(msg.sender, tokenId, amount);
    }

  
    function getFractionalOwnership(uint256 tokenId) external view returns (uint256) {
        return fractionalOwnership[tokenId][msg.sender];
    }

  
    function withdraw(uint256 tokenId, uint256 amount) external onlyOwner {
        require(musicNFT.ownerOf(tokenId) == address(this), "Music track not held by contract");
        require(fractionalOwnership[tokenId][msg.sender] >= amount, "Insufficient fractional ownership");

        fractionalizedToken.transfer(msg.sender, amount);
        fractionalOwnership[tokenId][msg.sender] -= amount;

        if (fractionalOwnership[tokenId][msg.sender] == 0) {
            musicNFT.transferFrom(address(this), msg.sender, tokenId);
        }
    }

    event FractionPurchased(address indexed buyer, uint256 tokenId, uint256 amount);
}
