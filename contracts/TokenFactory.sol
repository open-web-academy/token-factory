// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol";

contract TokenFactory {
    MyToken[] public _tokens;

    function createToken(
        address tokenOwner,
        string memory name,
        string memory ticker,
        uint256 amount
    ) public returns (uint256) {
        MyToken token = new MyToken(tokenOwner, name, ticker, amount);
        _tokens.push(token);
    }

    function allTokens(uint256 limit, uint256 offset)
        public
        view
        returns (MyToken[] memory)
    {
        uint256 endIndex = offset + limit;
        if (endIndex > _tokens.length) {
            endIndex = _tokens.length;
        }
        MyToken[] memory tokens = new MyToken[](endIndex - offset);
        for (uint256 i = offset; i < endIndex; i++) {
            tokens[i - offset] = _tokens[i];
        }
        return tokens;
    }

    function getNumberTokens() external view returns (uint256) {
        return _tokens.length;
    }
}