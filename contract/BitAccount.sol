pragma solidity ^0.4.21;

// Each account is a contract on the blockchain
// Each account has public and private information
// The private information is encrypted
contract BitsAccount {

  struct Bit {
    uint timestamp;
    string bitString;
  }

  // Struct -- each friend is associated with
  // an address (contract address) and they are
  // associated with a password that is encrypted
  // with this contract's own private key.
  struct Friend {
    address addr;
    string encryptedPw;
  }

  // Friends list
  Friend[] private friends;
  Friend[] private pendingFriends;
  uint numFriends;
  uint numPendingFriends;
  mapping (address => Friend) fromAddressToFriend;
  mapping (address => Friend) fromAddressToPendingFriend;

  // Public tweets
  mapping (uint => Bit) public publicBits;
  uint public numPublicBits;

  // Private tweets
  mapping (uint => Bit) public privateBits;
  uint public numPrivateBits;

  // Only the owner/user should be allowed to tweet
  address owner;

  // Password encrypted with the user's private key
  bytes32 encryptedPassword;

  // Takes in a password encrypted with the user's private key
  function BitsAccount(bytes32 _encryptedPassword) public {
    numPublicBits = 0;
    numPrivateBits = 0;
    numFriends = 0;
    numPendingFriends = 0;
    owner = msg.sender;
    encryptedPassword = _encryptedPassword;
  }

  // Modifier to ensure only the owner can control his account
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  // Create new public bit
  function postPublicBit(string _bitString) public onlyOwner {
    require (bytes(_bitString).length <= 160);

    publicBits[numPublicBits].timestamp = now;
    publicBits[numPublicBits].bitString = _bitString;
    numPublicBits++;
  }

  // Create new private (encrypted) bit
  function postPrivateBit(string _encryptedBitString) public onlyOwner {
    require (bytes(_encryptedBitString).length <= 160);

    privateBits[numPrivateBits].timestamp = now;
    privateBits[numPrivateBits].bitString = _encryptedBitString;
    numPrivateBits++;
  }

  // Get a public bit by ID
  function getPublicBit(uint _bitId) public constant returns (string bitString, uint timestamp) {
    bitString = publicBits[_bitId].bitString;
    timestamp = publicBits[_bitId].timestamp;
  }

  // Get a private bit by ID
  function getPrivateBit(uint _bitId) public constant returns (string bitString, uint timestamp) {
    bitString = privateBits[_bitId].bitString;
    timestamp = privateBits[_bitId].timestamp;
  }

  // Get the latest public bit
  function getLatestPublicBit() public constant returns (string bitString, uint timestamp) {
    bitString = publicBits[numPublicBits - 1].bitString;
    timestamp = publicBits[numPublicBits - 1].timestamp;
  }

  // Get the latest private bit
  function getLatestPrivateBit() public constant returns (string encryptedBitString, uint timestamp) {
    encryptedBitString = privateBits[numPrivateBits - 1].bitString;
    timestamp = privateBits[numPrivateBits - 1].timestamp;
  }

  // Accept a friend request; adds to the list.
  function receiveFriendRequest(address requester, string pw) public returns (bool) {
    Friend memory friend = Friend(requester, pw);
    fromAddressToPendingFriend[requester] = friend;
    pendingFriends.push(friend);
    numPendingFriends++;
    return true;
  }

  // Send a friend request to a specific address. The pw
  // must be encrypted with the TARGET's public key.
  function sendFriendRequest(address friendAddress, string pw) onlyOwner public returns (bool) {
    BitsAccount acct = BitsAccount(friendAddress);
    bool successful = acct.receiveFriendRequest(msg.sender, pw);
    require(successful);
    return true;
  }

  // Iterates through a list and deletes the 
  function deleteFromPendingList(address deleteAddress) onlyOwner private returns (bool) {
    for (uint i = 0; i < numPendingFriends; i++) {
      if (pendingFriends[i].addr == deleteAddress) {
	delete pendingFriends[i];
	numPendingFriends--;
	return true;
      }
    }
    return false;
  }

  // Accept a friend request. Only the owner can do this.
  function acceptFriendRequest(address acceptAddress) onlyOwner public returns (bool) {
    Friend storage pendingFriend = fromAddressToPendingFriend[acceptAddress];
    if (pendingFriend.addr != 0) {   // If address exists, good to go.

      // Add to friends.
      friends.push(pendingFriend);
      fromAddressToFriend[acceptAddress] = pendingFriend;

      // Delete from pending friends LIST.
      deleteFromPendingList(pendingFriend.addr);
      delete fromAddressToPendingFriend[pendingFriend.addr];

      numFriends++;
      return true;
    }
    return false;
  }

  // Returns an array of addresses.
  function getAllFriends() onlyOwner public view returns (address []) {
    address[] memory addressList = new address[](numFriends);
    for (uint i = 0; i < numFriends; i++) {
      addressList[i] = friends[i].addr;
    }
    return addressList;
  }

  // @TODO: DRY/refactor
  function getAllPendingFriends() onlyOwner public view returns (address []) {
    address[] memory addressList = new address[](numPendingFriends);
    for (uint i = 0; i < numPendingFriends; i++) {
      addressList[i] = pendingFriends[i].addr;
    }
    return addressList;
  }

  // @TODO: Check to see if it exists.
  function getEncryptedPw(address addr) onlyOwner public view returns (string str) {
    return fromAddressToFriend[addr].encryptedPw;
  }

}

