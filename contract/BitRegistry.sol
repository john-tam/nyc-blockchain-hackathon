pragma solidity ^0.4.21;

// Central registry, allows lookup of information
// Accounts can set their username by calling the "register" function
// Also stores "accounts id" which is the index of the accounts id, needed for account lookup
pragma solidity ^0.4.21;

contract BitAccountRegistry {

  // Account lookup information
  mapping (address => string) private addressToAccountName;
  mapping (uint => address) private idToAccountAddress;
  mapping (string => address) private accountNameToAddress;

  // How many users we have
  uint public numAccounts;

  // Constructor
  function BitAccountRegistry() public {
    numAccounts = 0;
  }

  // Lookup name from address
  function lookupNameFromAddress(address _address) public view returns (string) {
      return addressToAccountName[_address];
  }

  // Lookup address from id
  function lookupAddressFromId(uint _id) public view returns (address) {
      return idToAccountAddress[_id];
  }

  // Lookup address from name
  function lookupAddressFromName(string _name) public view returns (address) {
      return accountNameToAddress[_name];
  }


  // Set an account's username and mapping info
  // Currently, once a username is assigned it cannot be changed
  function register(string _name) public {
    // Revert if account name is taken
    require(accountNameToAddress[_name] == address(0));

    // Revert if account already has a name
    require(bytes(addressToAccountName[msg.sender]).length == 0);

    // Revert if supplied name is longer than 64 characters
    require(bytes(_name).length < 64);

    // Set lookup info
    addressToAccountName[msg.sender] = _name;
    accountNameToAddress[_name] = msg.sender;
    idToAccountAddress[numAccounts] = msg.sender;
    numAccounts++;
  }
}

