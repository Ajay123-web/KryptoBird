// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';

contract ERC721 is ERC165, IERC721 {
    
    mapping(uint256 => address) private _tokenOwner; //token id to address of owner
    mapping(address => uint256) private _ownedTokenCount; //total tokens owned
    mapping(uint256 => address) private _tokenApprovals;  //tokenId to approved address
    mapping(address => mapping(address => bool)) private _operatorApprovals; // mapping from owner to operator approvals

    constructor(){
        _registerInterface(bytes4(keccak256("balanceOf(bytes4)") ^ keccak256("transferFrom(bytes4)")
         ^ keccak256("approve(bytes4)")));
    }

    function balanceOf(address _owner) public override view returns (uint256) {
        require(_owner != address(0), "Owner query not valid.");
        return _ownedTokenCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public override view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "Token does not exist");
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        //if the token is owned by some valid address then it exists
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: Minting to a zero address");
        require(!_exists(tokenId), "ERC721: Token already minted"); //require that the token does not exist
        _tokenOwner[tokenId] = to;
        _ownedTokenCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal{
        require(_to != address(0), 'ERC721: transfer to a zero address');
        require(ownerOf(_tokenId) == _from, 'Trying to tranfer token which is not owned');

        _ownedTokenCount[_from] -= 1;
        _tokenOwner[_tokenId] = _to;
        _ownedTokenCount[_to] += 1;

        emit Transfer(_from, _to, _tokenId);
        
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public override {
        require(isApprovedOrOwner(msg.sender , _tokenId) , 'Not authorised');
        _transferFrom(_from , _to , _tokenId);
    }

    function approve(address _to , uint256 tokenId) public override {
        address owner = ownerOf(tokenId);
        require(_to != owner , 'Error: Approving itself is not allowed');
        require(msg.sender == owner || isApprovedForAll(owner , msg.sender) , 'Only owner is allowed to perform this action');
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner , _to , tokenId);
    }
   
    function isApprovedOrOwner(address spender , uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId), 'Token does not exist');
        address owner = ownerOf(tokenId);
        return (spender == owner || _tokenApprovals[tokenId] == spender || isApprovedForAll(owner , spender));
    }

    function _setApprovalForAll(address owner, address operator, bool approved) internal{
        require(owner != operator, "ERC721: Approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }
    function setApprovalForAll(address operator, bool approved) public override {
        _setApprovalForAll(msg.sender, operator, approved);
    }
    

    //is the operator allowed to trade all tokens of owner
    function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        return _operatorApprovals[owner][operator];
    }
}
