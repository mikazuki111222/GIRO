// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Giro_nft is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCount;
    string private _baseTokenURI;
    event nftMint (address indexed mint_to,uint256 token_id);
   

    constructor() ERC721("Gironft", "puzze") {}

    function mint(address to_) onlyOwner external {
        _tokenIdCount.increment();
        uint256 _tokenId = _tokenIdCount.current();
        _mint(to_, _tokenId);
        emit nftMint(to_,_tokenId);  
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function updateBaseTokenURI(string memory baseTokenURI_) public onlyOwner {
        _baseTokenURI = baseTokenURI_;
    }

    function tokenURI(uint256 tokenId_)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(tokenId_), "MyNFT: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return string(abi.encodePacked(baseURI, tokenId_));
    }
    function test(uint a, string calldata uint256 tokenId_) external pure returns(uint, string memory) {
        string memory encoded = encode(a, uint256 tokenId_);
        return decode(encoded);
    }    
}