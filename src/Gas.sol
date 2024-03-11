// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

import "./Ownable.sol";

contract Constants {
    uint8 constant tradeFlag = 1;
    uint8 constant dividendFlag = 1;
}

// "Gas Contract Only Admin Check-  Caller not admin"

error AdminCheckFailed();
error SenderCheckFailed();
error InvalidUserTier(uint256 tier);
error InvalidUserAddress();
error InsufficientBalance();
error InvalidNameLength();
error WrongTierLevel();
error InvalidArgument();

contract GasContract is Constants {

    uint256 immutable private totalSupply; // cannot be updated
    mapping(address => uint256) public balances;
    address immutable private contractOwner;
    mapping(address => uint256) public whitelist;
    address[5] public administrators;
    mapping(address => bool) administrators2;


    History[] private paymentHistory; // when a payment was updated

    struct Payment {
        uint256 paymentID;
        bool adminUpdated;
        string recipientName; // max 8 characters
        address recipient;
        address admin; // administrators address
        uint256 amount;
    }

    struct History {
        uint256 lastUpdate;
        address updatedBy;
        uint256 blockNumber;
    }

    struct ImportantStruct {
        uint256 amount;
        uint256 valueA; // max 3 digits
        uint256 bigValue;
        uint256 valueB; // max 3 digits
        address sender;
        bool paymentStatus;
    }
    mapping(address => ImportantStruct) private whiteListStruct;

    event AddedToWhitelist(address userAddress, uint256 tier);

    modifier onlyAdminOrOwner() {
        if (checkForAdmin(msg.sender) || msg.sender == contractOwner) {
            _;
        } else {
            revert AdminCheckFailed();
        }
    }

    modifier checkIfWhiteListed(address sender) {
        if (msg.sender != sender) revert SenderCheckFailed();
        uint256 usersTier = whitelist[msg.sender];
        if (usersTier <= 0 || usersTier >=4) revert InvalidUserTier(usersTier);
        _;
    }

    event supplyChanged(address indexed, uint256 indexed);
    event Transfer(address recipient, uint256 amount);
    event PaymentUpdated(
        address admin,
        uint256 ID,
        uint256 amount,
        string recipient
    );
    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        contractOwner = msg.sender;
        totalSupply = _totalSupply;

        for (uint256 i = 0; i < _admins.length;) {
            if (_admins[i] == address(0)) continue;

            administrators[i] = _admins[i];
            administrators2[_admins[i]] = true;
            if (_admins[i] == msg.sender) {
                balances[msg.sender] = _totalSupply;
                emit supplyChanged(_admins[i], _totalSupply);
            } else {
                balances[_admins[i]] = 0;
                emit supplyChanged(_admins[i], 0);
            }
            unchecked {
                ++i;
            }

        }
    }


    function checkForAdmin(address _user) public view returns (bool admin_) {
        admin_ = administrators2[_user];
    }

    function balanceOf(address _user) public view returns (uint256 balance_) {
        return balances[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public {
        address senderOfTx = msg.sender;
        if (balances[senderOfTx] < _amount) revert InsufficientBalance();
        if (bytes(_name).length >= 9) revert InvalidNameLength();
        unchecked {
            balances[senderOfTx] -= _amount;
            balances[_recipient] += _amount;
        }
        emit Transfer(_recipient, _amount);
    }

    function addToWhitelist(address _userAddrs, uint256 _tier)
        public
        onlyAdminOrOwner
    {
        if (_tier >= 255) revert WrongTierLevel();
        emit AddedToWhitelist(_userAddrs, _tier);
        if (_tier > 3) {
            _tier = 3;
        }
        whitelist[_userAddrs] = _tier;
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount
    ) public checkIfWhiteListed(msg.sender) {
        address senderOfTx = msg.sender;
        whiteListStruct[senderOfTx] = ImportantStruct(_amount, 0, 0, 0, msg.sender, true);
        if (balances[senderOfTx] < _amount) revert InvalidArgument();
        if (_amount <= 3) revert InvalidArgument();

        uint256 val = whitelist[senderOfTx];
        balances[senderOfTx] -= (_amount - val);
        balances[_recipient] += (_amount - val);

        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(address sender) public view returns (bool, uint256) {
        ImportantStruct memory s = whiteListStruct[sender];
        return (s.paymentStatus, s.amount);
    }

    receive() external payable {
        payable(msg.sender).transfer(msg.value);
    }

}