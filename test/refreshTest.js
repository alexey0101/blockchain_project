const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Refresh", function () {
  it("Should refresh rock, papper, scissors game", async function () {
    const RockPaperScissors = await ethers.getContractFactory("RockPapperScissors");
    const rockPaperScissors = await RockPaperScissors.deploy();

    const Refresh = await ethers.getContractFactory("Refresh");
    const refresh = await Refresh.deploy(rockPaperScissors.address);

    const [owner1, addr1] = await ethers.getSigners();
    const [owner2, addr2] = await ethers.getSigners();

    expect(await rockPaperScissors.gameState()).to.equal(0);
    //1 = Rock, 2 = Paper, 3 - Scissors, second argument = blinding
    const player1CommitHash = await rockPaperScissors.connect(addr1).getHash(1, 45);
    await rockPaperScissors.connect(addr1).commit(player1CommitHash);

    expect(await rockPaperScissors.gameState()).to.equal(1);
    await refresh.refreshGame();
    expect(await rockPaperScissors.gameState()).to.equal(0);
  });
});