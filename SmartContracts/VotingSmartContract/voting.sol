// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract Voting{
    address public owner;
    mapping(string=>uint) public votes;
    mapping(address=>bool) public voters;
    string[] public candidates;
    string[] winners;

    modifier candidateExists(string memory _candidate){
        bool candidate_exists = false;
        for (uint i = 0 ; i < candidates.length; i++) {
            if (keccak256(abi.encodePacked(candidates[i])) == keccak256(abi.encodePacked(_candidate))) {
                candidate_exists = true;
                break;
            }
        }
        if (candidate_exists){
            _;
        } else {
            revert("Candidate Does not exists!");
        }        
    }
    
    constructor() {
        owner = msg.sender;
    }

    function registerCandidate(string memory _candidate) public {
        require(msg.sender == owner, "Only owner can register candidates");
        for (uint i = 0; i < candidates.length; i++) {
            require(keccak256(abi.encodePacked(candidates[i])) != keccak256(abi.encodePacked(_candidate)), "Candidate already exists");
        }
        candidates.push(_candidate);
        votes[_candidate] = 0;
    }

    function vote(string memory _candidate) candidateExists(_candidate) public {
        require(voters[msg.sender] == false, "You have already voted");
        voters[msg.sender] = true;
        votes[_candidate] += 1;
    }

    function getCandidates() public view returns(string[] memory) {
        return candidates;
    }

    function getVotes(string memory _candidate) candidateExists(_candidate) public view returns(uint votes_count) {
        return votes[_candidate];
    }

    function getWinner() public returns(string[] memory, uint max_votes) {
        max_votes = 0;
        for (uint i=0; i< candidates.length; i++){
            if (votes[candidates[i]] > max_votes){
                max_votes = votes[candidates[i]];
            }
        }
        delete winners;
        for (uint i=0; i< candidates.length; i++){
            if (votes[candidates[i]] == max_votes){
                winners.push(candidates[i]);
            }
        }
        return (winners,max_votes); 
    }

    
}