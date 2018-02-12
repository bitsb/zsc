/*
Copyright (c) 2018, ZSC Dev Team
2018-02-09: v0.01
*/

pragma solidity ^0.4.17;
import "./db_entity.sol";

contract DBItem is DBEntity {
    uint templateID_;
    
    // Constructor
    function DBItem(string _name) public DBEntity(_name) {
    }
    
    function initParameters() internal {
        addParameter("assurerType");
    }

    function setTemplateID(uint _templateID) public onlyOwner {
        templateID_= _templateID;
    }

    function getTemplateID() public onlyOwner constant returns (uint) {
        return templateID_;
    }

    
}