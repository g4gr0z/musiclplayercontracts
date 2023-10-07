// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract MusicNFT is ERC721Enumerable, Ownable {
    using Address for address;

    string private baseTokenURI;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseTokenURI,
        address initialOwner
    ) ERC721(_name, _symbol) Ownable(initialOwner) {
        baseTokenURI = _baseTokenURI;
    }

    function setBaseTokenURI(string memory _newBaseTokenURI) external onlyOwner {
        baseTokenURI = _newBaseTokenURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function mint(address to, uint256 tokenId) external onlyOwner {
        _mint(to, tokenId);
    }

    function burn(uint256 tokenId) external onlyOwner {
        _burn(tokenId);
    }
}
