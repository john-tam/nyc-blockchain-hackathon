# NYC Blockchain Hack: EthBits
##### A simple decentralized microblogging platform with encrypted messages on the blockchain.
------
Using the Ethereum blockchain and its Solidity language, we created a decentralized version of Twitter, where each account is a contract on the blockchain, and has both public and private information. A "bit" is akin to a tweet. EthBits has the following features:

1. "Friending" functionality, which requires two-way verification (sendFriendRequest, acceptFriendRequest)
2. Create public posts, viewable to anyone (postPublicBit)
3. Create private posts, viewable only by friends (postPrivateBit)
4. List of pending friend requests, or all requests sent by other users (getAllPendingFriends)
5. Aggregate views of the user's public bits, private bits, and friends lists.

Authors:
Caitlin Bahari (cbahari); Caleb Ditchfield (ditchfieldcaleb); Linda Ge (linda-ge); John Tam (john-tam)
