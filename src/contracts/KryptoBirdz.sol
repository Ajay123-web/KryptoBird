// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './ERC721Connector.sol';

contract Kryptobird is ERC721Connector{
    string[] public kryptoBirdz;
    mapping(string => bool) _kryptoBirdzExists;
    constructor() ERC721Connector("KryptoBirdz" , "KBIRDZ"){
    }

    function mint(string memory _kryptoBird) public{
        require(!_kryptoBirdzExists[_kryptoBird] , 'Error - kryptoBird already exists');
        kryptoBirdz.push(_kryptoBird);
        uint _id = kryptoBirdz.length - 1;
        _mint(msg.sender , _id); 

        _kryptoBirdzExists[_kryptoBird] = true;
    }
}


