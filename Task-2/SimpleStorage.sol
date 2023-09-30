// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Shreyas Ruikar - Task 2 (Creating a smart contract)
//This smart contract serves as a decentralized storage system for managing individual user data.
//Including their favorite numbers, personal information (name, age, and gender).


contract SimpleStorage {
    address public owner;
    uint256 public favoriteNumber;
    uint256[] public favoriteNumbers;
   
    struct Person {
        uint256[] favoriteNumbers;
        string name;
        uint256 age;
    }
   
    mapping(address => Person) public people;
   
    enum Gender { Male, Female, Other }
    mapping(address => Gender) public personGenders;
   
    event FavoriteNumberSet(address indexed user, uint256 favoriteNumber);
    event PersonAdded(address indexed user, string name, uint256 age, uint256[] favoriteNumbers);
   
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
   
    modifier onlyPositive(uint256 number) {
        require(number > 0, "Number must be positive");
        _;
    }
   
   
    constructor(uint256 initialFavoriteNumber) {
        owner = msg.sender;
        favoriteNumber = initialFavoriteNumber;
    }
   

    receive() external payable {
        // Handle incoming Ether transactions here (if needed)
    }
   
   
    function setFavoriteNumber(uint256 _favoriteNumber) public onlyPositive(_favoriteNumber) {
        favoriteNumber = _favoriteNumber;
        favoriteNumbers.push(_favoriteNumber);
        emit FavoriteNumberSet(msg.sender, _favoriteNumber);
    }
   
    function getFavoriteNumbersCount() public view returns (uint256) {
        return favoriteNumbers.length;
    }
   
    function addPerson(string memory _name, uint256 _age, uint256[] memory _favoriteNumbers, Gender _gender) public onlyPositive(_age) {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(people[msg.sender].age == 0, "Person with this address already exists");
       
        Person memory newPerson = Person(_favoriteNumbers, _name, _age);
        people[msg.sender] = newPerson;
        personGenders[msg.sender] = _gender;
       
        emit PersonAdded(msg.sender, _name, _age, _favoriteNumbers);
    }
   
    function updatePersonInfo(string memory _name, uint256 _age, Gender _gender) public onlyPositive(_age) {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(people[msg.sender].age > 0, "Person with this address does not exist");
       
        Person storage existingPerson = people[msg.sender];
        existingPerson.name = _name;
        existingPerson.age = _age;
        personGenders[msg.sender] = _gender;
    }
   
    function addFavoriteNumber(uint256 _favoriteNumber) public onlyPositive(_favoriteNumber) {
        require(people[msg.sender].age > 0, "Person with this address does not exist");
       
        people[msg.sender].favoriteNumbers.push(_favoriteNumber);
    }
}
