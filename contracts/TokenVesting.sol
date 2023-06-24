// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenVesting {
    struct Vesting {
        address beneficiary;
        uint256 cliffDuration;
        uint256 vestingDuration;
        uint256 start;
        uint256 totalTokens;
        uint256 releasedTokens;
        address tokenAddress;
    }

    mapping(address => Vesting) public vestings;

    constructor() {}

    function setVesting(
        address _beneficiary,
        uint256 _cliffDuration,
        uint256 _vestingDuration,
        uint256 _start,
        uint256 _totalTokens,
        address _tokenAddress
    ) external {
        require(
            _beneficiary != address(0),
            "TokenVesting: beneficiary is the zero address"
        );
        require(
            _cliffDuration <= _vestingDuration,
            "TokenVesting: cliff duration exceeds vesting duration"
        );
        require(
            _start + _vestingDuration > block.timestamp,
            "TokenVesting: vesting end timestamp precedes current timestamp"
        );

        Vesting storage vesting = vestings[_beneficiary];
        require(vesting.beneficiary == address(0), "TokenVesting: vesting already exists for the beneficiary");

        vesting.beneficiary = _beneficiary;
        vesting.cliffDuration = _cliffDuration;
        vesting.vestingDuration = _vestingDuration;
        vesting.start = _start;
        vesting.totalTokens = _totalTokens;
        vesting.tokenAddress = _tokenAddress;

        IERC20 token = IERC20(_tokenAddress);
        token.transferFrom(msg.sender, address(this), _totalTokens);
    }

    function release() public {
        Vesting storage vesting = vestings[msg.sender];
        require(vesting.beneficiary != address(0), "TokenVesting: no vesting found for sender");

        require(block.timestamp >= vesting.start, "TokenVesting: vesting has not started yet");

        IERC20 token = IERC20(vesting.tokenAddress);
        uint256 vestedTokens = vestedAmount(vesting);
        uint256 unreleasedTokens = vestedTokens - vesting.releasedTokens;
        require(unreleasedTokens > 0, "TokenVesting: no tokens to release");

        vesting.releasedTokens = vestedTokens;
        token.transfer(vesting.beneficiary, unreleasedTokens);
    }

    function vestedAmount(Vesting memory _vesting) internal view returns (uint256) {
        IERC20 token = IERC20(_vesting.tokenAddress);
        uint256 currentBalance = token.balanceOf(address(this));
        uint256 totalVestingTime = _vesting.start + _vesting.vestingDuration;
        if (block.timestamp < _vesting.start + _vesting.cliffDuration) {
            return 0;
        } else if (block.timestamp >= totalVestingTime) {
            return _vesting.totalTokens;
        } else {
            uint256 vestedPercentage = (block.timestamp - _vesting.start - _vesting.cliffDuration) * 100 / _vesting.vestingDuration;
            return _vesting.totalTokens * vestedPercentage / 100;
        }
    }
}