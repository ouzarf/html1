// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract TraceabilityRegistry {
    struct Lot { string product; string origin; string metadataURI; address creator; uint64 createdAt; bool exists; }
    struct Stage { string stageType; string location; string metadataURI; address actor; uint64 timestamp; }
    mapping(bytes32 => Lot) private lots;
    mapping(bytes32 => Stage[]) private history;
    event LotCreated(bytes32 indexed lotId, string product, string origin, address indexed creator);
    event StageAdded(bytes32 indexed lotId, string stageType, string location, address indexed actor);
    function createLot(bytes32 lotId,string calldata product,string calldata origin,string calldata metadataURI) external { require(!lots[lotId].exists,"LOT_EXISTS"); lots[lotId]=Lot(product,origin,metadataURI,msg.sender,uint64(block.timestamp),true); emit LotCreated(lotId,product,origin,msg.sender); }
    function addStage(bytes32 lotId,string calldata stageType,string calldata location,string calldata metadataURI) external { require(lots[lotId].exists,"LOT_NOT_FOUND"); history[lotId].push(Stage(stageType,location,metadataURI,msg.sender,uint64(block.timestamp))); emit StageAdded(lotId,stageType,location,msg.sender); }
    function getLot(bytes32 lotId) external view returns(Lot memory){require(lots[lotId].exists,"LOT_NOT_FOUND");return lots[lotId];}
    function getStageCount(bytes32 lotId) external view returns(uint256){return history[lotId].length;}
    function getStage(bytes32 lotId,uint256 index) external view returns(Stage memory){return history[lotId][index];}
}
