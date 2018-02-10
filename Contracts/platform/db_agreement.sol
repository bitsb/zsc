/*
Copyright (c) 2018, ZSC Dev Team
2017-12-18: v0.01
2018-02-08: v0.01
*/

pragma solidity ^0.4.17;

library DBAgreement {
    enum ContractType {UNDEFINED, ETH, ZSC}
    enum AgreementStatus { UNDEFINED, ONGOING, CANCLED, PAID, NOTPAID}

    struct Agreement {
        ContractType    type_;
        string  name_ ;
        uint    id_ ;
        bool    activated_;
        uint[]  receivers_;
        uint[]  providers_;
        uint[]  receivers_eth_;
        uint[]  receivers_zsc_;
        uint[]  providers_eth_;
        uint[]  providers_zsc_;
        uint[]  agreements_;

        mapping(uint => uint) agreementExist_;
        mapping(uint => AgreementStatus) agreementStatus_;
    }

    function initAgreement(DBItem storage _agreement) public {
        DBEntity.insertParameter(_agreement.entity_, "startDate");
        DBEntity.insertParameter(_agreement.entity_, "endDate");
        DBEntity.insertParameter(_agreement.entity_, "signDate");
        DBEntity.insertParameter(_agreement.entity_, "insuredAmount");
        DBEntity.insertParameter(_agreement.entity_, "paymentAmount");
    }

    function addProvider(Agreement storage _agreement, uint _provider_index, uint _ethValue, uint _zscValue)  public {
        for (uint i = 0; i < _agreement.providers_.length; ++i) {
           if (_agreement.providers_[i] == _provider_index) {
                revert();
            }
        }
        _agreement.providers_.push(_provider_index);
        _agreement.providers_eth_.push(_ethValue);
        _agreement.providers_zsc_.push(_zscValue);
    }

    function removeProvider(Agreement storage _agreement, uint _provider_index)  public {
        for (uint i = 0; i < _agreement.providers_.length; ++i) {
           if (_agreement.providers_[i] == _provider_index) {
                _agreement.providers_[i] = _agreement.providers_[_agreement.providers_.length - 1];
                _agreement.providers_eth_[i] = _agreement.providers_eth_[_agreement.providers_eth_.length - 1];
                _agreement.providers_zsc_[i] = _agreement.providers_zsc_[_agreement.providers_zsc_.length - 1];
                break;
            }
        }
        _agreement.providers_.length -= 1;
        _agreement.providers_eth_.length -= 1;
        _agreement.providers_zsc_.length -= 1;
    }

    function addReceiver(Agreement storage _agreement, uint _receiver_index, uint _ethValue, uint _zscValue)  public {
        for (uint i = 0; i < _agreement.providers_.length; ++i) {
           if (_agreement.providers_[i] == _receiver_index) {
                revert();
            }
        }
        _agreement.receivers_.push(_receiver_index);
        _agreement.receivers_eth_.push(_ethValue);
        _agreement.receivers_zsc_.push(_zscValue);
    }

    function removeReceiver(Agreement storage _agreement, uint _receiver_index)  public {
        for (uint i = 0; i < _agreement.receivers_.length; ++i) {
           if (_agreement.receivers_[i] == _receiver_index) {
                _agreement.receivers_[i] = _agreement.receivers_[_agreement.receivers_.length - 1];
                _agreement.receivers_eth_[i] = _agreement.receivers_eth_[_agreement.receivers_eth_.length - 1];
                _agreement.receivers_zsc_[i] = _agreement.receivers_zsc_[_agreement.receivers_zsc_.length - 1];
                break;
            }
        }
        _agreement.receivers_.length -= 1;
        _agreement.receivers_eth_.length -= 1;
        _agreement.receivers_zsc_.length -= 1;
    }


    //////////////////////////////////

    function addAgreement(Entity storage _entity, uint _agreementID) public returns (bool) {
        if (_entity.agreementExist_[_agreementID] == 0)
            return false;

        _entity.agreementExist_[_agreementID] = 1;
        _entity.agreementStatus_[_agreementID] = AgreementStatus.ONGOING;
        _entity.agreements_.push(_agreementID);

        return true;
    }

    function setAgreementStatus(Entity storage _entity, uint _agreementID, AgreementStatus _status) public returns (bool) {
        if (_entity.agreementExist_[_agreementID] == 0)
            return false;

        _entity.agreementStatus_[_agreementID] = _status;

        return true;
    }
}