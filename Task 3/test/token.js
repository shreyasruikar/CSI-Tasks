const { ethers } = require("hardhat");
const { expect } = require("chai");

//To debug use: import "hardhat/console.sol"; 

describe("Token Contract", function () {
    let Token;
    let hardhatToken;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function () {
        Token = await ethers.getContractFactory("Token");
        [owner, addr1, addr2] = await ethers.getSigners();
        hardhatToken = await Token.deploy(); // Corrected: Added parentheses to deploy
    });

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            expect(await hardhatToken.owner()).to.equal(owner.address);
        });

        it("Should assign total supply of tokens to owner", async function () {
            const ownerBalance = await hardhatToken.balanceOf(owner.address);
            expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
        });
    });

    describe("Transactions", function () {
        it("Should transfer tokens between accounts", async function () {
            await hardhatToken.transfer(addr1.address, 5);
            const addr1Balance = await hardhatToken.balanceOf(addr1.address);
            expect(addr1Balance).to.equal(5);

            await hardhatToken.connect(addr1).transfer(addr2.address, 5);
            const addr2balance = await hardhatToken.balanceOf(addr2.address);
            expect(addr2balance).to.equal(5);
        });

        it("Should fail if sender does not have enough tokens", async function () {
            const initialOwnerBalance = await hardhatToken.balanceOf(owner.address);
            await expect(hardhatToken.connect(addr1).transfer(owner.address, 1)).to.be.revertedWith("Not enough tokens"); // Corrected typo: "if" instead of "it"
            expect(await hardhatToken.balanceOf(owner.address)).to.equal(
                initialOwnerBalance
            );
        });

    it("Should update balances after transactions",async function(){
        const initialOwnerBalance = await hardhatToken.balanceOf(owner.address);
        await hardhatToken.transfer(addr1.address,5);
        await hardhatToken.transfer(addr2.address,10);

        const finalOwnerBalance = await hardhatToken.balanceOf(owner.address);
        expect(finalOwnerBalance).to.equal(initialOwnerBalance-15);

        const addr1Balance = await hardhatToken.balanceOf(addr1.address);
        expect(addr1Balance).to.equal(5);

        const addr2Balance = await hardhatToken.balanceOf(addr2.address);
        expect(addr2Balance).to.equal(10);
      });
    });
});
