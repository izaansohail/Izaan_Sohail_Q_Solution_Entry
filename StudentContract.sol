// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./QTKN.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./SchoolContract.sol";

contract StudentContract is ERC721URIStorage{
    address public owner;
    QTKN private currentToken;
    SchoolSmartContract private schoolT;
    uint256 public accountBalance;

    using Counters for Counters.Counter; 
    Counters.Counter private _tokenIds;

    constructor(string memory courseName,string memory courseCode) ERC721(courseName, courseCode) {
    }

    function createToken(string memory tokenURI) public returns (uint) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    
}
