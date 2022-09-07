// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./ERC721Enumerable.sol";
import "./Ownable.sol";
import "./Strings.sol";


contract RhinoXNFT is ERC721Enumerable, Ownable {
    using Strings for uint256;

    uint256 public MAX_SUPPLY;
    uint256 public MAX_PURCHASE;
    uint256 public MAX_MINT = 1;
    uint256 public DROP_INTERVAL = 100;
    string public META_EXTENSION = ".json";
    string public PROVENANCE_HASH;

    address public COIN_ADDRESS; 

    string public _baseTokenURI;
    string public _notRevealedURI;
    bool public _revealed = false;

    struct Auction {
        uint256 amount;
        uint256 startPrice;
        uint256 endPrice;
        uint256 blockCount;
        uint256 endBlock;
        uint256 dropInterval;
    }
                            

    // Mapping owner address to purchase amount
    mapping(address => uint256) private _purchaseAmounts;

    constructor(string memory name, string memory symbol, uint256 maxSupply, uint256 maxPurchase, address coinAddress, address receiveAddress) ERC721(name, symbol) {
        MAX_SUPPLY = maxSupply;
        MAX_PURCHASE = maxPurchase;
        COIN_ADDRESS = coinAddress;
        RECEIVE_ADDRESS = receiveAddress;
    }

    function setMaxPurchase(uint256 maxPurchase) public onlyOwner {
        MAX_PURCHASE = maxPurchase;
    }

    function setMaxMint(uint256 maxMint) public onlyOwner {
        MAX_MINT = maxMint;
    }

    function setDropInterval(uint256 dropInterval) public onlyOwner {
        DROP_INTERVAL = dropInterval;
    }

    function setMetaExtension(string memory metaExtension) public onlyOwner {
        META_EXTENSION = metaExtension;
    }

    function setProvenanceHash(string memory provenanceHash) public onlyOwner {
        PROVENANCE_HASH = provenanceHash;
    }

    function setCoinAddress(address coinAddress) public onlyOwner {
        COIN_ADDRESS = coinAddress;
    }

    function setReceiveAddress(address receiveAddress) public onlyOwner {
        RECEIVE_ADDRESS = receiveAddress;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function setNotRevealedURI(string memory notRevealedURI) public onlyOwner {
        _notRevealedURI = notRevealedURI;
    }

    function flipReveal() public onlyOwner {
        _revealed = !_revealed;
    } 

    function _mintToken(address to, uint256 amount) internal {
        for (uint256 i = 0; i < amount; i++) {
            uint256 tokenId = totalSupply();
            if (totalSupply() < MAX_SUPPLY) {
                _safeMint(to, tokenId);
            }
        }
    }

    function reserveToken(address to, uint256 amount) public onlyOwner {
        require(block.number >= _auction.endBlock, "Current auction is not stopped");
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceed max supply");
        _mintToken(to, amount);
    }

    function mintToken(uint256 amount) public {
        require(amount <= MAX_MINT, "Can only mint 1 token at a time");
        require(amount <= _auction.amount, "Purchase would exceed max amount of auction");
        require(_purchaseAmounts[msg.sender] + amount <= MAX_PURCHASE, "Purchase would exceed max balance of address");

        uint256 cost = currentPrice() * amount;
        IERC20(COIN_ADDRESS).transferFrom(msg.sender, RECEIVE_ADDRESS, cost);

        _mintToken(msg.sender, amount);

        _purchaseAmounts[msg.sender] += amount;
        _auction.amount -= amount;
    }
}