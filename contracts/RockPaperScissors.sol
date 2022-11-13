// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title RockPapperScissors
 * @dev Play Rock, Papper, Scissors game
 */
contract RockPapperScissors {

    enum Choice { Commited, Rock, Paper, Scissors }

    enum State { FirstCommit, SecondCommit, FirstReveal, SecondReveal }

    event CommitHash(address player, bytes32 commitHash);

    event Reveal(address player, Choice choice);

    event GameResult(address player1, address player2, string result);

    struct Player {
        address player;
        Choice choice;
        bytes32 commitHash;
        bool revealed;
    }

    modifier commitStage {
        require(gameState == State.FirstCommit || gameState == State.SecondCommit,
        "ERROR: Player commited their choices, it's reveal stage!");
        _;
    }

    modifier revealStage(Choice choice) {
        require(gameState == State.FirstReveal || gameState == State.SecondReveal,
        "ERROR: Players should commit their choices before the reveal stage!");
        require(choice != Choice.Commited, "ERROR: Incorrect choice");
        _;
    }

    Player[2] players;
    State gameState = State.FirstCommit;

    function getHash(Choice choice, uint blinding) public view returns(bytes32){
        return keccak256(abi.encodePacked(msg.sender, choice, blinding));
    }

    function commit(bytes32 commitHash) public commitStage {
        if (gameState == State.FirstCommit) {
            players[0] = Player(msg.sender, Choice.Commited, commitHash, false);
        } else if (gameState == State.SecondCommit) {
            require(players[0].player != msg.sender, "Player already commited choice!");
            players[1] = Player(msg.sender, Choice.Commited, commitHash, false);
        }

        if (gameState == State.FirstCommit) {
            gameState = State.SecondCommit;
        } else {
            gameState = State.FirstReveal;
        }

        emit CommitHash(msg.sender, commitHash);
    }

    function reveal(Choice choice, uint blinding) public revealStage(choice) {
        Player storage player;
        if (msg.sender == players[0].player) {
            player = players[0];
        } else {
            player = players[1];
        }

        require(!player.revealed, "Player already revealed choice!");
        require(keccak256(abi.encodePacked(msg.sender, choice, blinding)) == player.commitHash, "Invalid hash!");

        player.choice = choice;
        player.revealed = true;

        emit Reveal(msg.sender, choice);

        if (gameState == State.FirstReveal) {
            gameState = State.SecondReveal;
        } else {
            if (players[0].choice == players[1].choice) {
                emit GameResult(players[0].player, players[1].player, "Draw!");
            } else {
                if (players[0].choice == Choice.Rock) {
                    if (players[1].choice == Choice.Scissors) {
                        emit GameResult(players[0].player, players[1].player, "Player 1 wins!");
                    } else {
                        emit GameResult(players[0].player, players[1].player, "Player 2 wins!");
                    }
                }
                if (players[0].choice == Choice.Paper) {
                    if (players[1].choice == Choice.Rock) {
                        emit GameResult(players[0].player, players[1].player, "Player 1 wins!");
                    } else {
                        emit GameResult(players[0].player, players[1].player, "Player 2 wins!");
                    }
                }
                if (players[0].choice == Choice.Scissors) {
                    if (players[1].choice == Choice.Paper) {
                        emit GameResult(players[0].player, players[1].player, "Player 1 wins!");
                    } else {
                        emit GameResult(players[0].player, players[1].player, "Player 2 wins!");
                    }
                }
            }

            delete players;
            gameState = State.FirstCommit;
        }
    }
}