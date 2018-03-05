/*
Copyright (c) 2018 ZSC Dev Team
*/

pragma solidity ^0.4.18;

import "./plat_string.sol";
import "./object.sol";
import "./db_node.sol";

contract DBDatabase is Object {
    bytes32 temp_;
    address public rootNode_ = 0;
    DBNode[] public nodes_;
    mapping(bytes32 => address) nodeAddress_;

    /*added on 2018-02-25*/
    struct NodeParameterValue {mapping (bytes32 => string) values_; }
    mapping (bytes32 => NodeParameterValue) nodeParameters_;

    function DBDatabase(bytes32 _name) public Object(_name) {
    }

    function initDatabase(address _factory) public only_delegate () {
        if (rootNode_ == 0) {
            setDelegate(_factory, true);

            rootNode_ = new DBNode(name());
            setDelegate(rootNode_, true);
            DBNode(rootNode_).setDelegate(this, true);
            DBNode(rootNode_).setDelegate(_factory, true);
            DBNode(rootNode_).setDatabase(address(this));
        }
    }
    
    function getRootNode() public only_delegate constant returns (address) {
        return rootNode_;
    }

    function getNode(bytes32 _name) public only_delegate constant returns (address) {
        return nodeAddress_[_name];
    }

    function _addNode(address _node) public only_delegate {
        require (nodeAddress_[DBNode(_node).name()] == 0);

        DBNode(_node).setDelegate(owner, true);
        nodes_.push(DBNode(_node));
        nodeAddress_[DBNode(_node).name()] = _node;
    }

    function destroyNode(address _node) public only_delegate returns (bool) {
        for (uint i = 0; i < nodes_.length; ++i) {
            if (address(nodes_[i]) == _node) {
                address parent = nodes_[i].getParent();
                if (parent != 0) {

                    DBNode(parent).removeChild(nodes_[i].name());
                    nodes_[i].removeAndDestroyAllChildren();
                }
                nodes_[i] = nodes_[nodes_.length - 1];
                break;
            }    
        }
        delete nodes_[nodes_.length - 1];
        nodes_.length --;
            
        delete nodeAddress_[DBNode(_node).name()];
        setDelegate(_node, false);

        delete _node;

        return true;
    }

    function destroyNode(bytes32 _name) public only_delegate returns (bool) {
        address nd = nodeAddress_[_name];
        if (nd == 0) return false;
        return destroyNode(nd);
    }
}
