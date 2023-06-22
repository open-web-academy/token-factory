// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// CODE NOT AUDITED
// USE ONLY FOR EDUCATIONAL PURPOSE

contract TokenVesting {
    address public token;                           // Address of the token being vested
    mapping(address => uint256) public vestingSchedule;  // Mapping to track vesting schedules

    constructor(address _token) {
        token = _token;
    }

    function setVestingSchedule(address _beneficiary, uint256 _amount, uint256 _releaseTime) external {
        require(_amount > 0, "Amount must be greater than zero");

        // Perform token transfer to the vesting contract
        IERC20(token).transferFrom(msg.sender, address(this), _amount);  // Transfer `_amount` tokens from the sender to the vesting contract

        vestingSchedule[_beneficiary] = _releaseTime;
    }

    function releaseTokens() external {
        uint256 releaseTime = vestingSchedule[msg.sender];
        require(releaseTime > 0 && block.timestamp >= releaseTime, "Tokens not yet released");

        // Perform token transfer to the beneficiary
        IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));  // Transfer all remaining tokens in the vesting contract to the beneficiary

        // Reset the release time to prevent multiple releases
        vestingSchedule[msg.sender] = 0;

        // Emit an event to indicate a successful token release
        emit TokensReleased(msg.sender);
    }

    event TokensReleased(address indexed beneficiary);
}