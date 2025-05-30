// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract BountyVault {
    address public admin;

    struct Bounty {
        string title;
        string description;
        uint256 reward;
        address hunter;
        bool isClaimed;
    }

    uint256 public bountyCount;
    mapping(uint256 => Bounty) public bounties;

    event BountyPosted(uint256 bountyId, string title, uint256 reward);
    event BountyClaimed(uint256 bountyId, address hunter);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function postBounty(string memory title, string memory description) external payable onlyAdmin {
        require(msg.value > 0, "Reward must be > 0");

        bounties[bountyCount] = Bounty({
            title: title,
            description: description,
            reward: msg.value,
            hunter: address(0),
            isClaimed: false
        });

        emit BountyPosted(bountyCount, title, msg.value);
        bountyCount++;
    }

    function claimBounty(uint256 bountyId, address hunter) external onlyAdmin {
        Bounty storage b = bounties[bountyId];
        require(!b.isClaimed, "Already claimed");

        b.isClaimed = true;
        b.hunter = hunter;
        payable(hunter).transfer(b.reward);

        emit BountyClaimed(bountyId, hunter);
    }

    function getBounty(uint256 bountyId) external view returns (
        string memory, string memory, uint256, address, bool
    ) {
        Bounty storage b = bounties[bountyId];
        return (b.title, b.description, b.reward, b.hunter, b.isClaimed);
    }
}
