pragma solidity ^0.8.0;

contract StubListing {
    uint256 public tokenId;
    uint256 public askPrice;
    address public tokenAddress;

    constructor(
        uint256 _tokenId,
        uint256 _askPrice,
        address _tokenAddress
    ) {
        tokenId = _tokenId;
        askPrice = _askPrice;
        tokenAddress = _tokenAddress;
    }

    function details()
        public
        view
        returns (
            uint256 _tokenId,
            uint256 _askPrice,
            address _tokenAddress
        )
    {
        _tokenId = this.tokenId();
        _askPrice = this.askPrice();
        _tokenAddress = this.tokenAddress();
    }
}
