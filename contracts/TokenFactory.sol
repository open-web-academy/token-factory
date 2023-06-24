// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol";

contract TokenFactory {
    MyToken[] public _tokens;
    event MensajeImpreso(string mensaje);

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


    /*
    function tokensCreatedByAddress(address creator,uint256 limit, uint256 offset)
        public
        view
        returns (MyToken[] memory)
    {
        uint256 count = 0;
        /*for (uint256 i = 0; i < _tokens.length; i++) {
            if (_tokens[i].owner() == creator) {
                count++;
            }
        }
        
        uint256 endIndex = offset + limit;
        MyToken[] memory userTokens = new MyToken[](endIndex - offset);
        uint256 index = 0;
        for (uint256 i = 0; i < _tokens.length; i++) {
            if (_tokens[i].owner() == creator) {
                userTokens[index] = _tokens[i];
                index++;
            }
        }
       

        MyToken[] memory tokens = new MyToken[](endIndex - offset);
        for (uint256 i = offset; i < endIndex; i++) {
            tokens[i - offset] = _tokens[i];
        }
        return userTokens;
    }*/
}