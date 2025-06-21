// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    string public s_name;
    string public s_description;
    uint public s_goal;
    uint public s_deadline;
    address public s_owner;
    bool public s_paused;

    struct Tier {
        string name;
        uint amount;
        uint backers;
    }

    struct Backer {
        uint totalContribution;
        mapping(uint => bool) fundedTiers;
    }

    mapping(address => Backer) public s_backers;

    enum CampaignState {Active, Succesful, Failed}
    CampaignState public s_state;

    Tier[] public s_tiers;

    modifier onlyOwner() {
        require(s_owner == msg.sender, "Not the owner of this");
        _;
    }

    modifier campaignOpen() {
        require(s_state == CampaignState.Active, "Campaign is no longer active");
        _;
    }

    modifier notPaused() {
        require(!s_paused, "Campaign is paused");
        _;
    }

    constructor (
        address _owner,
        string memory _name,
        string memory _description,
        uint _goal,
        uint _deadline
    ) {
        s_name = _name;
        s_description = _description;
        s_goal = _goal;
        s_deadline = block.timestamp + (_deadline * 1 days);
        s_owner = _owner;
        s_state = CampaignState.Active;
    }

    function checkAndUpdateCampaignState() internal {
        if(s_state == CampaignState.Active) {
            if(block.timestamp >= s_deadline) {
                s_state = address(this).balance >= s_goal ? CampaignState.Succesful : CampaignState.Failed;
            } else {
                s_state = address(this).balance >= s_goal ? CampaignState.Succesful : CampaignState.Active;
            }
        }
    }

    function fund (uint _tierIndex) public payable campaignOpen notPaused {
        require(_tierIndex < s_tiers.length, "Invalid tier");
        require(msg.value == s_tiers[_tierIndex].amount, "The amount of the Ether doesn't match with the tier");

        s_tiers[_tierIndex].backers++;
        s_backers[msg.sender].totalContribution += msg.value;
        s_backers[msg.sender].fundedTiers[_tierIndex] = true;

        checkAndUpdateCampaignState();
    }

    function withdraw() public onlyOwner {
        checkAndUpdateCampaignState();
        require(s_state == CampaignState.Succesful, "Campaign not succesful");
        uint balance = address(this).balance;
        (bool sent,) = payable(s_owner).call{value: balance}("");
        require(sent, "Could not send Ether to address");
    }

    function getContractBalance() public view returns(uint256) {
        return address(this).balance;
    }

    function addTier(string memory _name, uint _amount) public onlyOwner {
        require(_amount > 0, "The amount of the tier must be greater than zero");
        s_tiers.push(Tier(_name, _amount, 1));
    }

    function removeTier(uint _index) public onlyOwner {
        require(_index < s_tiers.length, "There is no such tier");
        s_tiers[_index] = s_tiers[s_tiers.length - 1];
        s_tiers.pop();
    }

    function refund() public {
        checkAndUpdateCampaignState();
        require(s_state == CampaignState.Failed, "Refunds not available");
        uint amount = s_backers[msg.sender].totalContribution;
        require(amount > 0, "No funds to refund");

        s_backers[msg.sender].totalContribution = 0;
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Could not send Ether to address");
    }

    function hasFundedTier(address _backer, uint _tierIndex) public view returns(bool) {
        return s_backers[_backer].fundedTiers[_tierIndex];
    }

    function getTiers() public view returns(Tier[] memory) {
        return s_tiers;
    }

    function togglePause() public onlyOwner {
        s_paused = !s_paused;
    }

    function getCampaignStatus() public view returns(CampaignState) {
        if(s_state == CampaignState.Active && block.timestamp > s_deadline) {
            return address(this).balance >= s_goal ? CampaignState.Succesful : CampaignState.Failed;
        }
        return s_state;
    }

    function extendDeadLine(uint _daysToAdd) public onlyOwner campaignOpen {
        s_deadline += _daysToAdd * 1 days;
    }
}