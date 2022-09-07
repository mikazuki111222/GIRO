// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyToken is ERC1155, Ownable {
    string private URI_TOKEN;
    uint256 public max_Supply;
    uint256 public MAX_PURCHASE;
    uint256 public MAX_MINT=5;

    struct Auction {
        uint256 amount;
    }
    Auction public _auction = Auction(100);

    
    // Mapping owner address to purchase amount
    mapping(address => uint256) private _purchaseAmounts;


    constructor() ERC1155("") {}
//-------------------------SET VARRIBLE---------------------------------------//
    function setMaxPurchase(uint256 max_Purchase) public onlyOwner {
        MAX_PURCHASE = max_Purchase;
    }

    function setMaxSupply(uint256 max_Supply)public onlyOwner{
        MAX_SUPPLY = max_Supply;
    }

    function setMaxMint(uint256 max_Mint) public onlyOwner{
        MAX_MINT= max_Mint;
    }




    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {   
        require(amount <= _auction.amount, "Purchase would exceed max amount of auction");
        require(amount <= MAX_MINT, "Can only mint 5 token at a time");
        require(_purchaseAmounts[msg.sender] + amount <= MAX_PURCHASE, "Purchase would exceed max balance of address");
        _mint(account, id, amount, data);
        _purchaseAmounts[msg.sender] += amount;
        _auction.amount -= amount;
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function openBox1(address account_open,uint256 id_open,uint256 amount_open,bytes memory data,uint256[] memory id_claim,uint256[] memory amounts_claim) public onlyOwner {
        require(id_open == 1 , "erros box");
        require(balanceOf(account_open,id_open)>=amount_open,"not enought");
        _burn(account_open, id_open, amount_open);
        _mintBatch(account_open, id_claim, amounts_claim,data);
    }

//----------------------------URI-------------------------------//
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
        URI_TOKEN = newuri;
    }

    function uri(uint256 tokenId_)public view virtual override returns (string memory )
    {
        string memory URI_GIRO = URI_TOKEN;
        return string(abi.encodePacked(URI_GIRO,Strings.toString(tokenId_)));
    }


}