// Central registry, allows lookup of information
// Accounts can set their username by calling the "register" function
// Also stores "accounts id" which is the index of the accounts id, needed for account lookup
contract BitAccountRegistry {

	// Account lookup information
	mapping (address => string) public addressToAccountName;
	mapping (uint => address) public idToAccountName;
	mapping (string => address) public accountNameToAddress;

	// How many users we have
	uint public numAccounts;

	// Constructor
	function BitAccountRegistry() {
		numAccounts = 0;
	}

	// Set an account's username and mapping info
	// Currently, once a username is assigned it cannot be changed
	function register(string _name) {
		// Revert if account name is taken
		require(accountNameToAddress[name] == address(0));

		// Revert if account already has a name
		require(addressToAccountName[msg.sender].legnth == 0);

		// Revert if supplied name is longer than 64 characters
		require(bytes(name).length < 64);

		// Set lookup info
		addressToAccountName[msg.sender] = name;
		accountNameToAddress[name] = msg.sender;
		accountIdToAccountAddress[numAccounts] = accountAddress;
		numAccounts++;
	}
}
