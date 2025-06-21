// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Crowdfunding} from "./Crowdfunding.sol";

contract CrowdfundingFactory {
    address public s_owner;
    bool public s_paused;

    struct Campaign {
        address campaignAddress;
        address owner;
        string name;
        uint creationTime;
    }

    Campaign[] public s_campaigns;
    mapping(address => Campaign) public s_userCampaigns;

    modifier onlyOwner() {
        require(s_owner == msg.sender, "Not the owner of this");
        _;
    }

    modifier notPaused() {
        require(!s_paused, "Campaign is paused");
        _;
    }

    constructor() {
        s_owner = msg.sender;
    }

    function createCampaign(
        string memory _name,
        string memory _description,
        uint _goal,
        uint _deadline
    ) external notPaused {
        Crowdfunding newCampaign = new Crowdfunding(msg.sender, _name, _description, _goal, _deadline);
        address campaignAddress = address(newCampaign);

        Campaign memory campaign = Campaign({
            campaignAddress: campaignAddress,
            owner: msg.sender,
            name: _name,
            creationTime: block.timestamp
        });

        s_campaigns.push(campaign);
        s_userCampaigns[msg.sender] = campaign;   
    }

    function getUserCampaigns(address _user) external view returns(Campaign[] memory) {
        Campaign[] memory result = new Campaign[](1);
        result[0] = s_userCampaigns[_user];
        return result;
    }

    function getAllCampaigns() external view returns(Campaign[] memory){
        return s_campaigns;
    }

     function togglePause() external onlyOwner {
        s_paused = !s_paused;
    }
}