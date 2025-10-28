// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BlockSecure Voting System
 * @dev A decentralized, transparent, and secure voting system built on Ethereum.
 */
contract BlockSecureVotingSystem {
    address public admin;
    bool public votingActive;

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    mapping(address => bool) public hasVoted;
    Candidate[] public candidates;

    event CandidateAdded(string name);
    event VoteCast(address indexed voter, uint256 candidateId);
    event VotingStarted();
    event VotingEnded();

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Add a candidate (Admin only, before voting starts)
     * @param _name The name of the candidate
     */
    function addCandidate(string memory _name) external {
        require(msg.sender == admin, "Only admin can add candidates");
        require(!votingActive, "Cannot add candidates after voting starts");

        candidates.push(Candidate({name: _name, voteCount: 0}));
        emit CandidateAdded(_name);
    }

    /**
     * @notice Start the voting process (Admin only)
     */
    function startVoting() external {
        require(msg.sender == admin, "Only admin can start voting");
        require(!votingActive, "Voting already started");
        require(candidates.length > 0, "No candidates added");

        votingActive = true;
        emit VotingStarted();
    }

    /**
     * @notice Cast a vote for a candidate
     * @param candidateId The ID of the candidate to vote for
     */
    function vote(uint256 candidateId) external {
        require(votingActive, "Voting is not active");
        require(!hasVoted[msg.sender], "You have already voted");
        require(candidateId < candidates.length, "Invalid candidate");

        candidates[candidateId].voteCount++;
        hasVoted[msg.sender] = true;

        emit VoteCast(msg.sender, candidateId);
    }

    /**
     * @notice End the voting process (Admin only)
     */
    function endVoting() external {
        require(msg.sender == admin, "Only admin can end voting");
        require(votingActive, "Voting is not active");

        votingActive = false;
        emit VotingEnded();
    }

    /**
     * @notice Get total number of candidates
     */
    function getCandidatesCount() external view returns (uint256) {
        return candidates.length;
    }

    /**
     * @notice Get candidate details by ID
     * @param candidateId The ID of the candidate
     */
    function getCandidate(uint256 candidateId)
        external
        view
        returns (string memory name, uint256 votes)
    {
        require(candidateId < candidates.length, "Invalid candidate ID");
        Candidate storage candidate = candidates[candidateId];
        return (candidate.name, candidate.voteCount);
    }
}

