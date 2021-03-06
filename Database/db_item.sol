/*
Copyright (c) 2018, ZSC Dev Team
2018-02-09: v0.01
*/

pragma solidity ^0.4.17;
import "./db_entity.sol";

contract DBItem is DBEntity {   
    // Constructor
    function DBItem(bytes32 _name) public DBEntity(_name) {
    	setEntityType("item");
    }
    
    function initParameters() internal {
        addParameter("description");
    }
    
}
