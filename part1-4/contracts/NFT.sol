// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721Enumerable, Ownable {
    string public metadataURI;
    string public groupName = "blockchainValley";

    uint constant MINT_AMOUNT = 10;
    uint public cost = 1 ether;
    uint public specialCost = 2 ether;
    uint public registerFee = 2 ether;

    mapping(address => uint) public mintableOf
    mapping(address => bool) public isMintedAddress;
    mapping(address => bool) public isGroupAddress;
    mapping(uint => UserData) public userData;

    constructor(string memory _metadataURI) ERC721("cardNFT", "NFT") {
        metadataURI = _metadataURI;
    }

    event Mint(address indexed owner, string name, string group, string job, bool isGroupMember);
    event RegisterMember(address indexed member);

    struct UserData {
        address wallet;
        string name;
        string group;
        string job;
        bool isGroupMember;
    }

    function registerGroup() external payable {
        require(msg.value == registerFee, "YOU HAVE TO PAY EXACT COST");
        require(!isGroupAddress[msg.sender], "YOU ARE ALREADY MEMBER OF GROUP");
        isGroupAddress[msg.sender] = true;
        emit RegisterMember(msg.sender);
    }

    function mintGroupNft(string calldata _name, string calldata _job) external payable {
        require(msg.value == specialCost, "YOU HAVE TO PAY EXACT COST");
        require(isGroupAddress[msg.sender], "NOT ALLOWED ADDRESS");
        require(mintableOf[msg.sender] > 0, "YOU ALREADY MINT 10 NFTS");
        uint tokenId = totalSupply() + 1;
        _safeMint(msg.sender, tokenId);
        mintableOf[msg.sender] -= 1;
        userData[tokenId] = UserData(msg.sender, _name, groupName, _job, true);
        emit Mint(msg.sender, _name, groupName, _job, true);
    }

    function allowMintNft() external payable {
        require(msg.value == cost, "YOU HAVE TO PAY EXACT COST");
        require(!isMintedAddress[msg.sender], "ALREADY MINTED ADDRESS");
        mintableOf[msg.sender] += 10;
        isMintedAddress[msg.sender] = true;
    }

    function _transfer(address from, address to, uint256 tokenId) internal override {
        super._transfer(from, to, tokenId);
    }


    function tokenURI(uint _tokenId) public override view returns(string memory) {
        return string(abi.encodePacked(metadataURI, '/', Strings.toString(_tokenId), '.json'));
    }

    function setCost(uint _newCost) external onlyOwner {
        cost = _newCost;
    }

    function setSpecialCost(uint _newSpecialCost) external onlyOwner {
        specialCost = _newSpecialCost;
    }

    function withdraw() external payable onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "THERE IS NO BALANCE TO WITHDRAW");
        payable(msg.sender).transfer(balance);
    }
}