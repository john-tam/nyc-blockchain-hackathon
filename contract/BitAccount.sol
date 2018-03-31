pragma solidity ^0.4.21;

// Each account is a contract on the blockchain
// Each account has public and private information
// The private information is encrypted
contract BitsAccount {

	struct Bit {
		uint timestamp;
		string bitString;
	}

	// Public tweets
	mapping (uint => Bit) public publicBits;
	uint public numPublicBits;

	// Private tweets
	mapping (uint => Bit) public privateBits;
	uint public numPrivateBits;

	// Friends list
  address[] friends;

	// Only the owner/user should be allowed to tweet
	address owner;

	// Password encrypted with the user's private key
	bytes32 encryptedPassword;

	// Takes in a password encrypted with the user's private key
	function BitsAccount(bytes32 _encryptedPassword) public {
		numPublicBits = 0;
		numPrivateBits = 0;
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

	// Add an address to friends list
  function addToFriendsList(address friend) public onlyOwner {
  	friends.push(friend);
  }
}