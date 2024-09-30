// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    address public marketplaceOwner;
    uint public ownerFeePercentage = 5;

    struct Product {
        string name;
        uint price;
        address payable seller;
        bool isSold;
    }

    mapping(uint => Product) public products;
    uint public productCounter;

    event ProductCreated(uint productId, string name, uint price, address seller);
    event ProductSold(uint productId, address buyer, address seller, uint price);

    // Constructor sets the marketplace owner to the contract deployer
    constructor() {
        marketplaceOwner = msg.sender;
    }

    // Function to create a new product
    function createProduct(string memory _name, uint _price) public {
        require(_price > 0, "Product price must be greater than 0");

        productCounter++;
        products[productCounter] = Product({
            name: _name,
            price: _price,
            seller: payable(msg.sender),
            isSold: false
        });

        emit ProductCreated(productCounter, _name, _price, msg.sender);
    }

    // Function to buy a product
    function buyProduct(uint _productId) public payable {
        Product storage product = products[_productId];
        require(_productId > 0 && _productId <= productCounter, "Product does not exist");
        require(msg.value == product.price, "Incorrect payment amount");
        require(!product.isSold, "Product is already sold");

        uint ownerFee = (product.price * ownerFeePercentage) / 100;
        uint sellerAmount = product.price - ownerFee;

        // Transfer 5% to the marketplace owner
        payable(marketplaceOwner).transfer(ownerFee);

        // Transfer 95% to the seller
        product.seller.transfer(sellerAmount);

        // Mark the product as sold
        product.isSold = true;

        emit ProductSold(_productId, msg.sender, product.seller, product.price);
    }
}