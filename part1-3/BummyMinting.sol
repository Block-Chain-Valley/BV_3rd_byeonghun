// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;


import "./BummyOwnership.sol";
import "./Interface/BummyMintingInterface.sol";
/// @title all functions related to creating kittens
contract BummyMinting is BummyOwnership,BummyMintingInterface {
    mapping(address => bool) alreadyMinted;
    // Limits the number of cats the contract owner can ever create.
    uint256 public promoCreationLimit = 100;
    uint256 public gen0CreationLimit = 500;

    // Counts the number of bummies the contract owner has created.
    uint256 public promoCreatedCount;
    uint256 public gen0CreatedCount;

    /// @dev we can create promo bummies, up to a limit. Only callable by COO
    /// @param _genes the encoded genes of the bummies to be created, any value is accepted
    /// @param _owner the future owner of the created bummies. Default to contract COO
    function createPromoBummy(uint256 _genes, address _owner) external override onlyCOO returns (uint256){
        if (_owner == address(0)) {
            _owner = cooAddress;
        }
        require(promoCreatedCount < promoCreationLimit);
        require(gen0CreatedCount < gen0CreationLimit);

        promoCreatedCount++;
        gen0CreatedCount++;
        uint256 newbummyId = _createBummy(0, 0, 0, _genes, _owner);
        return newbummyId;
    }


    function getRandomNumber(uint _range) internal returns (uint256)
    {
        uint256 randomNum = uint256(
            keccak256(
                abi.encode(
                    tx.gasprice,
                    block.number,
                    block.timestamp,
                    block.difficulty,
                    blockhash(block.number - 1),
                    address(this),
                    _range
                )
            )
        );
        uint256 randomNumber = 1 + randomNum % _range;
        return randomNumber;
    }

    /**
     * @dev user can create gen0bummy, but only one
     */
    function createFirstGen0Bummy() external returns (uint256){
        require(alreadyMinted[msg.sender] == false, "already minted");
        uint256 genes = getRandomNumber(gen0CreationLimit);
        uint256 newbummyId = _createBummy(0, 0, 0, genes, msg.sender);
        alreadyMinted[msg.sender] = true;
        gen0CreatedCount++;
        return newbummyId;
    }
}