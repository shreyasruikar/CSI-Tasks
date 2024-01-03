// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract UserManagement {
    struct User {
        string username;
        string email;
        string passwordHash;
        string securityAnswerHash;
        string securityQuestion;
        string profilePhoto;
    }

    mapping(address => User) public users;
    mapping(string => address) public emailToAddress;
    mapping(address => bool) public loggedInUsers;
    mapping(address => string) public passwordRecoveryTokens;

    event UserRegistered(address indexed userAddress, string username, string email);
    event UserProfileUpdated(address indexed userAddress, string newUsername, string newEmail, string newProfilePhoto);
    event PasswordRecoveryInitiated(address indexed userAddress, string recoveryToken);

    function registerUser(string memory _username,string memory _email,string memory _passwordHash,string memory _securityAnswerHash,string memory _securityQuestion) public {
        require(emailToAddress[_email] == address(0), "Email is already registered");

        address userAddress = msg.sender;
        users[userAddress] = User({
            username: _username,
            email: _email,
            passwordHash: _passwordHash,
            securityQuestion: _securityQuestion,
            securityAnswerHash: _securityAnswerHash,
            profilePhoto: ""
        });

        emailToAddress[_email] = userAddress;

        emit UserRegistered(userAddress, _username, _email);
    }

    function loginUser(string memory _email, string memory _passwordHash) public returns (bool) {
        address userAddress = emailToAddress[_email];
        require(userAddress != address(0), "User Not Found");
        require(keccak256(bytes(users[userAddress].passwordHash)) == keccak256(bytes(_passwordHash)), "Invalid Credentials");
        loggedInUsers[userAddress] = true;

        return true;
    }

    function updateProfile(string memory _newUsername, string memory _newEmail, string memory _newProfilePhoto) public {
        address userAddress = msg.sender;
        require(loggedInUsers[userAddress], "User not logged in");

        users[userAddress].username = _newUsername;
        users[userAddress].email = _newEmail;
        users[userAddress].profilePhoto = _newProfilePhoto;

        emit UserProfileUpdated(userAddress, _newUsername, _newEmail, _newProfilePhoto);
    }

    function recoverPassword(string memory _email, string memory _securityAnswerHash) public {
        address userAddress = emailToAddress[_email];
        require(userAddress != address(0), "User Not Found");

        require(keccak256(bytes(users[userAddress].securityAnswerHash)) == keccak256(bytes(_securityAnswerHash)), "Invalid Security Answer");

        string memory recoveryToken = "RecoveryToken123";
        passwordRecoveryTokens[userAddress] = recoveryToken;

        emit PasswordRecoveryInitiated(userAddress, recoveryToken);
    }
}
