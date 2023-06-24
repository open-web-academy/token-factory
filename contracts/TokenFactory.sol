// SPDX-License-Identifier: MIT
pragma solidity >0.4.23 <0.9.0;
import "./MyToken.sol";
contract TokenFactory {
    MyToken[] public _tokens;
    function createToken(
        address tokenOwner,
        string memory name,
        string memory ticker,
        uint256 amount
    ) 
    public returns (uint256) 
    {
        MyToken token = new MyToken(
            tokenOwner,
            name,
            ticker,
            amount
        );
        _tokens.push(token);
    }
    function allTokens(uint256 limit, uint256 offset)
        public
        view
        returns (MyToken[] memory coll)
    {
        return coll;
    }
}