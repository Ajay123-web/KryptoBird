// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is ERC721, IERC721Enumerable {
    uint256[] private _allTokens; //list of all tokens in smart contract
    mapping(uint256 => uint256) private _allTokensIndex; //mapping of every token Id to its index in _allTokens
    mapping(address => uint256[]) private _ownedTokens; //list of all tokenId owned by an address
    mapping(uint256 => uint256) private _ownedTokensIndex; //mapping of tokenId in the list of owned tokens of an address

    constructor(){
        _registerInterface(bytes4(keccak256("totalSupply(bytes4)") ^ keccak256("tokenByIndex(bytes4)")
         ^ keccak256("tokenOfOwnerByIndex(bytes4)")));
    }

    function tokenByIndex(uint256 _index) external view override returns (uint256){
        require(_index < totalSupply() , 'Global index is out of bounds');
        return _allTokens[_index];
    }
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view override returns (uint256){
        require(_index < balanceOf(_owner) , 'Owner index is out of bounds');
        return _ownedTokens[_owner][_index];
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        _addTokensToTotalSupply(tokenId);
        _addTokensToOwner(to , tokenId);
    }

    function _addTokensToTotalSupply(uint256 tokenId) private {
        _allTokens.push(tokenId);
        _allTokensIndex[tokenId] = _allTokens.length - 1;
    }

    function _addTokensToOwner(address to, uint256 tokenId) private {
        _ownedTokens[to].push(tokenId);
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length - 1;
    }

    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }
}
