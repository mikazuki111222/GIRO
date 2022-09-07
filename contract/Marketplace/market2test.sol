// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract market1155 is Ownable {
     using EnumerableSet for EnumerableSet.AddressSet;
    using SafeERC20 for IERC20;
    using Counters for Counters.Counter;

    struct Order {
        address seller;
        address buyer;
        uint256 tokenId;
        address paymentToken;
        uint256 price;
    }

    EnumerableSet.AddressSet private _supportedPaymentTokens;
    IERC1155 public immutable nftContract;
    uint256 public feeDecimal;
    uint256 public feeRate;
    address public feeRecipient;
    Counters.Counter private _orderIdCount;

    mapping(uint256 => Order) public orders;
}

