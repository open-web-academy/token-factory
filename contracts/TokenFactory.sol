// SPDX-License-Identifier: MIT
pragma solidity >0.4.23 <0.9.0;
import "./MyToken.sol";
contract TokenFactory {
    MyToken[] private _tokens;
    function createToken(
        string memory name,
        string memory description
    ) public {
        MyToken token = new MyToken(
            name,
            description
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